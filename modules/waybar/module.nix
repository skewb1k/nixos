{...}:
{
  programs.waybar = {
    enable = true;
  };
  home-manager.users.skewbik.home.file = {
    ".config/waybar/config.jsonc".source = ./config.jsonc;
    ".config/waybar/style.css".source = ./style.css;
  };
}