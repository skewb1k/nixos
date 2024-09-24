{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    go
    lua
    python3
    clang
    rustup
    nodePackages_latest.yarn
    nodePackages_latest.nodejs
    jdk
  ];
}