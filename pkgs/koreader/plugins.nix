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
  "autodim"
  "autofrontlight"
  "autostandby"
  "autosuspend"
  "autoturn"
  "autowarmth"
  "backgroundrunner"
  "batterystat"
  "bookshortcuts"
  "calibre"
  "coverbrowser"
  "coverimage"
  "docsettingtweak"
  "exporter"
  "externalkeyboard"
  "gestures"
  "hello"
  "japanese"
  "keepalive"
  "kosync"
  "movetoarchive"
  "newsdownloader"
  "opds"
  "patchmanagement"
  "perceptionexpander"
  "profiles"
  "qrclipboard"
  "readtimer"
  "SSH"
  "statistics"
  "systemstat"
  "terminal"
  "texteditor"
  "timesync"
  "vocabbuilder"
  "wallabag"
]
