{
  pkgs,
  ...
}:

{
  programs = {
    git.enable = true;
    lazygit.enable = true;
  };
  environment.systemPackages = [
    pkgs.gh
  ];
}