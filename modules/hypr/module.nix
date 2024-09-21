{ pkgs, username, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

  services = {
    xserver.enable = false;
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  environment.systemPackages = with pkgs; [
    hyprpicker
    swww
    hyprlock
    hyprshot
    rofi
    hypridle
    grim
    slurp
    dunst
    clipboard
    swaynotificationcenter
  ];
}