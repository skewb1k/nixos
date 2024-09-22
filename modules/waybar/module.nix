{ user, ...}:
{
  programs.waybar = {
    enable = true;
  };
  home-manager.users.${user}.home.file = {
    ".config/waybar/config.jsonc".source = ./config.jsonc;
    ".config/waybar/style.css".source = ./style.css;
  };
}