{ config, lib, pkgs, inputs, options, ... }:

let
  username = "skewbik";
  userDescription = "main user";
  homeDirectory = "/home/${username}";
  hostName = "thinkbook";
  timeZone = "Europe/Moscow";
in
{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.kernelModules = [ "amdgpu" ];
    # kernelPackages = pkgs.linuxPackages_zen;
    # extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # kernel.sysctl = {
    #   "vm.max_map_count" = 2147483642;
    # };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      timeout = 4;
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  };

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # stylix = {
  #   enable = true;
  #   base16Scheme = {
  #     base00 = "191724";
  #     base01 = "1f1d2e";
  #     base02 = "26233a";
  #     base03 = "6e6a86";
  #     base04 = "908caa";
  #     base05 = "e0def4";
  #     base06 = "e0def4";
  #     base07 = "524f67";
  #     base08 = "eb6f92";
  #     base09 = "f6c177";
  #     base0A = "ebbcba";
  #     base0B = "31748f";
  #     base0C = "9ccfd8";
  #     base0D = "c4a7e7";
  #     base0E = "f6c177";
  #     base0F = "524f67";
  #   };
  #   image = ../../config/assets/wall.png;
  #   polarity = "dark";
  #   opacity.terminal = 0.8;
  #   cursor.package = pkgs.bibata-cursors;
  #   cursor.name = "Bibata-Modern-Ice";
  #   cursor.size = 24;
  #   fonts = {
  #     monospace = {
  #       package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
  #       name = "JetBrainsMono Nerd Font Mono";
  #     };
  #     sansSerif = {
  #       package = pkgs.montserrat;
  #       name = "Montserrat";
  #     };
  #     serif = {
  #       package = pkgs.montserrat;
  #       name = "Montserrat";
  #     };
  #     sizes = {
  #       applications = 12;
  #       terminal = 15;
  #       desktop = 11;
  #       popups = 12;
  #     };
  #   };
  # };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases =
        let
          flakeDir = "~/rudra";
        in {
        rb = "sudo nixos-rebuild switch --flake ${flakeDir}";
        upd = "sudo nix flake update ${flakeDir}";
        upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";
        scg = "sudo nix-collect-garbage -d";
        hms = "home-manager switch --flake ${flakeDir}";
        hlr = "hyprctl reload";

        ff = "fastfetch";
        ".."="cd ..";
        v="vim";
        nv="nvim";
        c="clear";

        ssn="sudo shutdown 0";
        srb="sudo reboot 0";
        dcrm="docker container prune -f && docker image prune -f && docker network prune -f && docker volume prune -f";
      };
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "agnoster";
      };
    };
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    dconf.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = userDescription;
      extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "tss" "docker" ];
    };
  };

  environment.systemPackages = with pkgs; [
  # Text editors and IDEs
  vim neovim vscode zed-editor jetbrains.idea-community-bin neovide

  # Programming languages and tools
  go lua python3 clang rustup
  nodePackages_latest.pnpm nodePackages_latest.yarn nodePackages_latest.nodejs
  bun jdk fnm

  # Version control and development tools
  git gh lazygit lazydocker bruno gnumake coreutils nixfmt-rfc-style meson

  # Shell and terminal utilities
  stow wget killall eza starship alacritty zoxide fzf tmux progress tree

  # File management and archives
  yazi p7zip unzip unrar ncdu duf

  # System monitoring and management
  htop btop lm_sensors inxi
#   auto-cpufreq

  # Network and internet tools
  qbittorrent

  # Audio and video
  pulseaudio pavucontrol ffmpeg mpv

  # Image and graphics
  imagemagick nomacs gimp hyprpicker swww hyprlock imv

  # Productivity and office
  obsidian libreoffice-qt6-fresh spacedrive

  # Communication and social
  telegram-desktop vesktop

  # Browsers
  firefox-devedition

  # Gaming and entertainment
  stremio

  # System utilities
  libgcc bc kdePackages.dolphin lxqt.lxqt-policykit libnotify v4l-utils ydotool
  pciutils socat cowsay ripgrep lshw bat pkg-config brightnessctl virt-viewer
  swappy appimage-run yad playerctl nh ansible

  # Wayland specific
  hyprshot rofi hypridle grim slurp waybar dunst wl-clipboard swaynotificationcenter

  # Virtualization
  libvirt

  # File systems
  ntfs3g os-prober

  # Downloaders
  yt-dlp localsend

  # Clipboard managers
  cliphist

  # Fun and customization
  cmatrix lolcat fastfetch onefetch microfetch

  # Networking
  networkmanagerapplet

  # Music and streaming
  youtube-music spotify

];

  fonts.packages = with pkgs; [
    noto-fonts-emoji
    fira-sans
    roboto
    noto-fonts-cjk
    font-awesome
    material-icons
    jetbrains-mono
    fira-code
    fira-code-symbols
    nerd-font-patcher
  ];

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

  services = {
    xserver = {
      enable = false;
    };
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        initial_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
    supergfxd.enable = true;
    libinput.enable = true;
    fstrim.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    auto-cpufreq.enable = true;
    # syncthing = {
    #   enable = true;
    #   user = username;
    #   dataDir = homeDirectory;
    #   configDir = "${homeDirectory}/.config/syncthing";
    # };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  systemd.services = {
    flatpak-repo = {
      path = [ pkgs.flatpak ];
      script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio.enable = false;
    graphics = {
      enable = true;
      extraPackages = with pkgs;[
        amdvlk
      ];
      package = pkgs.mesa.drivers;
    };
  };

  services.blueman.enable = true;

  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    pam.services.swaylock.text = "auth include login";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  programs.hyprland = {
    enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs;};
    users.${username} = import ./home.nix;
    backupFileExtension = "backup";
  };

  system.stateVersion = "24.05";
}
