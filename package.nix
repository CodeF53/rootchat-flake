{
  appimageTools,
  fetchurl,
  lib,
  shaHash ? lib.fakeHash,
}:

let
  pname = "rootchat";
  version = "0.9.72";
  src = fetchurl {
    url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
    hash = shaHash;
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in

appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: with pkgs; [ stdenv.cc.cc.lib icu ];
  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/Root.desktop -t $out/share/applications
    install -Dm644 ${appimageContents}/Root.png $out/share/icons/hicolor/512x512/apps/Root.png
    substituteInPlace $out/share/applications/Root.desktop --replace 'Exec=Root' 'Exec=rootchat'
  '';
  
  meta = {
    description = "Chat app for gamers";
    homepage = "https://www.rootapp.com/";
    changelog = "https://www.rootapp.com/changelog";
    # commented out because its evil and makes it hard to use
    # license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "rootchat";
  };
}
