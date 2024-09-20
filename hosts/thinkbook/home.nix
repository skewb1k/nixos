{ config, pkgs, ... }:

let
  userName = "skewbik";
  homeDirectory = "/home/${userName}";
  stateVersion = "24.05";
in
{
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;
    pointerCursor = {
      name = "macOS-Monterey";
      package = pkgs.apple-cursor;
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };

    file = {
      # Hyprland Config
      ".config/hypr".source = ../../dotfiles/.config/hypr;

      # wlogout icons
      # ".config/wlogout/icons".source = ../../config/wlogout;

      # Top Level Files symlinks
      # ".zshrc".source = ../../dotfiles/.zshrc;
      ".zshenv".source = ../../dotfiles/.zshenv;
      # ".xinitrc".source = ../../dotfiles/.xinitrc;
      # ".gitconfig".source = ../../dotfiles/.gitconfig;
      # ".ideavimrc".source = ../../dotfiles/.ideavimrc;
      # ".nirc".source = ../../dotfiles/.nirc;
      # ".local/bin/wallpaper".source = ../../dotfiles/.local/bin/wallpaper;

      # Config directories
      # ".config/alacritty".source = ../../dotfiles/.config/alacritty;
      # ".config/dunst".source = ../../dotfiles/.config/dunst;
      # ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      # ".config/kitty".source = ../../dotfiles/.config/kitty;
      # ".config/mpv".source = ../../dotfiles/.config/mpv;
      # ".config/tmux/tmux.conf".source = ../../dotfiles/.config/tmux/tmux.conf;
      ".config/waybar".source = ../../dotfiles/.config/waybar;
      # ".config/yazi".source = ../../dotfiles/.config/yazi;
      # ".config/wezterm".source = ../../dotfiles/.config/wezterm;

      # Individual config files
      # ".config/kwalletrc".source = ../../dotfiles/.config/kwalletrc;
      # ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      # ".config/mimeapps.list".source = ../../dotfiles/.config/mimeapps.list;
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];
  };

  # imports = [
  #   ../../config/wlogout.nix
  # ];

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
