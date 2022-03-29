#!/usr/bin/env ruby

require "shellwords"

Dir.chdir(ARGV.shift)

class String
  def indent(n)
    self.split(/\n/).map { |s| "#{"  "*n}#{s}"}.join("\n")
  end
end

def get_hash(expr)
  cmd = [
    "nix-universal-prefetch",
    "-E",
    expr
  ]
  hash = `#{cmd.map(&:shellescape).join(" ")}`
end

# Hapazardly parse the CMakeLists for source info...
infos = Dir.glob("base/thirdparty/*/CMakeLists.txt").sort.map do |thirdparty|
  content = File.read(thirdparty)
  
  match = content.match(%r{\nko_write_gitclone_script\([^)]+\)})

  project = content.match(%r{project\(([^)]+)\)})[1]

  vars = content.scan(%r{set\(([^)]+)\)})

  vars = vars.map do |content|
    content = content.first
    tokens = content.split(/\s/, 2)
    [tokens.first, tokens.last.gsub(/"/, "")]
  end.to_h

  unless match
    match = content.match(%r{\nExternalProject_Add\(([^)]+)\)})

    unless match
      $stderr.puts "Warning: no downloader match in #{thirdparty}"
      next
    end

    raw = match[1].split(/\n/)
      .select { |s| s != "" }
      .map(&:strip)
      .map do |line|
        data = line.split(/\s+/, 2)
        [data.first, data.last]
      end.to_h

      url = raw["URL"].gsub(%r<\${[^}]+}>) do |match|
        key = match.sub(/^\${/, "").sub(/}$/, "")
        vars[key]
      end

      data = {
        type: :url,
        url: url,
      }
  else
    data = match[0].split(/[\n\s]/).select { |s| s != "" }
    data = {
      type: :git,
      url: data[2],
      rev: data[3],
    }
    if data[:rev].match(/^\${([^}]+)}/)
      #$stderr.puts "Warning: variable for rev #{$1}"
      data[:rev] = vars[$1]
    end

  end

  data[:project] = project

  data
end

deps = 
  infos.map do |info|
    next unless info

    fetcher =
      case info[:type]
      when :url
        base = <<~EOF
        fetchurl {
          url = "#{info[:url]}";
          hash = "";
        }
        EOF
        hash = get_hash("with (import <nixpkgs> {}); #{base}").strip
        base.sub('hash = ""', %Q{hash = "#{hash}"})
      when :git
        attrs = ""
        case info[:url]
        when %r{://github.com/}
          gitfetcher = "fetchFromGitHub"
          parts = info[:url].sub("https://github.com/", "").split("/")
          attrs = <<~EOF
            owner = "#{parts[0]}";
            repo = "#{parts[1].sub(/\.git$/, "")}";
          EOF
        when %r{://gitlab.com/}
          gitfetcher = "fetchFromGitLab"
          parts = info[:url].sub("https://gitlab.com/", "").split("/")
          # XXX incorrect
          attrs = <<~EOF
            owner = "#{parts[0]}";
            repo = "#{parts[1].sub(/\.git$/, "")}";
          EOF
        when %r{://framagit.org/}
          gitfetcher = "fetchFromGitLab"
          parts = info[:url].sub("https://framagit.org/", "").split("/")
          # XXX incorrect
          attrs = <<~EOF
            domain = "framagit.org";
            owner = "#{parts[0]}";
            repo = "#{parts[1].sub(/\.git$/, "")}";
          EOF
        else
          raise "Missing fetcher for #{info[:url]}"
        end
        base = <<~EOF
        #{gitfetcher} {
        #{attrs.indent(1)}
          rev = "#{info[:rev]}";
          hash = "";
        }
        EOF
        $stderr.puts("Downloading '#{info[:project]}'...")
        hash = get_hash("with (import <nixpkgs> {}); #{base}").strip
        base.sub('hash = ""', %Q{hash = "#{hash}"})
      end
    <<~EOF
    #{info[:project]} = {
      src = #{fetcher.indent(1).sub(/^\s+/, "")};
    };
    EOF
  end

puts([
  "{ fetchFromGitHub, fetchFromGitLab, fetchurl }:",
  "",
  "{",
  (deps.join("\n").indent(1)),
  "}",
].join("\n"))

# XXX : freetype2 is fetchSubmodules = true :/
