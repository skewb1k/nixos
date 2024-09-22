{
  inputs,
  lib,
  pkgs,
  options,
  user,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/zsh/module.nix
    ../../modules/waybar/module.nix
    ../../modules/virt.nix
    ../../modules/gnupg.nix
    ../../modules/hypr/module.nix
  ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.kernelModules = [ "amdgpu" ];

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
      timeout = 3;
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = "thinkbook";
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  };

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    users.${user} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "input"
        "wheel"
        "video"
        "audio"
        "tss"
        "docker"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    vim
    neovim
    vscode
    zed-editor
    # jetbrains.idea-community-bin
    neovide

    # Programming languages and tools
    go
    lua
    python3
    clang
    rustup
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    nodePackages_latest.nodejs
    bun
    jdk
    # fnm

    # Version control and development tools
    git
    gh
    lazygit
    lazydocker
    bruno
    gnumake
    coreutils
    nixfmt-rfc-style
    nil

    # Shell and terminal utilities
    wget
    killall
    eza
    starship
    alacritty
    zoxide
    fzf
    tmux
    tree

    # File management and archives
    yazi
    p7zip
    unzip
    unrar
    ncdu
    duf

    # System monitoring and management
    htop
    btop
    lm_sensors

    # Network and internet tools
    qbittorrent

    # Audio and video
    pulseaudio
    pavucontrol
    ffmpeg
    mpv

    # Image and graphics
    nomacs
    gimp
    imv

    # Productivity and office
    obsidian
    spacedrive

    # Communication and social
    telegram-desktop
    vesktop

    # Browsers
    firefox-devedition

    # Gaming and entertainment
    stremio

    # System utilities
    libgcc
    bc
    lxqt.lxqt-policykit
    libnotify
    # v4l-utils
    # ydotool
    # pciutils
    # socat
    # cowsay
    ripgrep
    lshw
    bat
    brightnessctl
    virt-viewer
    # swappy
    appimage-run
    playerctl
    nh

    # Virtualization
    libvirt

    # File systems
    ntfs3g
    os-prober

    # Downloaders
    yt-dlp

    # Clipboard managers
    cliphist

    # Fun and customization
    cmatrix
    fastfetch

    # Networking
    networkmanagerapplet

    # Music and streaming
    spotify
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

  services = {
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
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio.enable = false;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs user;
    };
    users.${user} = import ./home.nix;
    backupFileExtension = "backup";
  };

  system.stateVersion = "24.11";
}
