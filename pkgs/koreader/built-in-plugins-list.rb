#!/usr/bin/env ruby

class String
  def indent(n)
    self.split(/\n/).map { |s| "#{"  "*n}#{s}"}.join("\n")
  end
end

Dir.chdir(ARGV.shift)

plugin_dirs = Dir.glob("plugins/*.koplugin").map do |dir|
  dir.split("/").last
end
  .sort { |a, b| a.downcase <=> b.downcase }

puts <<~EOF
{ runCommand
, src }:
let
  makePlugin = name: runCommand "koreader-plugin-${name}" {} ''
    mkdir -p $out/lib/koreader/plugins
    cp -prf ${src}/plugins/${name}.koplugin $out/lib/koreader/plugins/${name}.koplugin
  '';
  makePlugins = list: builtins.listToAttrs (builtins.map (name: { inherit name; value = makePlugin name; }) list);
in
makePlugins [
EOF
plugin_dirs.each do |dir|
  puts <<~EOF
  "#{dir.sub(/\.koplugin$/, "")}"
  EOF
    .indent(1)
end
puts "]"
