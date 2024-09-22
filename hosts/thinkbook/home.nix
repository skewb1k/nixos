{
  config,
  pkgs,
  user,
  ...
}:

{
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "24.11";
    pointerCursor = {
      name = "macOS-Monterey";
      package = pkgs.apple-cursor;
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  # services.hypridle = {
  #   settings = {
  #     general = {
  #       after_sleep_cmd = "hyprctl dispatch dpms on";
  #       ignore_dbus_inhibit = false;
  #       lock_cmd = "hyprlock";
  #     };
  #     listener = [
  #       {
  #         timeout = 900;
  #         on-timeout = "hyprlock";
  #       }
  #       {
  #         timeout = 1200;
  #         on-timeout = "hyprctl dispatch dpms off";
  #         on-resume = "hyprctl dispatch dpms on";
  #       }
  #     ];
  #   };
  # };

  programs.home-manager.enable = true;
}
