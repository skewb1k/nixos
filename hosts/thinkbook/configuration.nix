{
  pkgs,
  inputs,
  options,
  user,
  stateVersion,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix.nix
    ../../modules/boot.nix
    ../../modules/flatpak.nix
    ../../modules/security.nix
    ../../modules/zsh/module.nix
    ../../modules/htop/module.nix
    ../../modules/nvim/module.nix
    ../../modules/alacritty/module.nix
    ../../modules/nh.nix
    ../../modules/git.nix
    ../../modules/gnupg.nix
    ../../modules/bluetooth.nix
    ../../modules/virt.nix
    ../../modules/waybar/module.nix
    ../../modules/hypr/module.nix
  ];
  users.users.${user} = {
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
  networking = {
    networkmanager.enable = true;
    # timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  };

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    vim
    vscode
    zed-editor
    # jetbrains.idea-community-bin
    neovide

    # Version control and development tools
    lazydocker
    bruno
    gnumake
    coreutils
    nixfmt-rfc-style
    nil

    # Shell and terminal utilities
    wget
    killall
    # eza
    starship
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
    chromium

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
    # nix-ld.enable = true;
    supergfxd.enable = true;
    libinput.enable = true;
    fstrim.enable = true;
    openssh.enable = true;
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

  hardware = {
    enableRedistributableFirmware = true;
    sane = {
      enable = true;
    };
    pulseaudio.enable = false;
    graphics = {
      enable = true;
      extraPackages = [
        pkgs.amdvlk
      ];
      package = pkgs.mesa.drivers;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit user stateVersion;
    };
    users.${user} = import ./home.nix;
    backupFileExtension = "backup";
  };

  system.stateVersion = stateVersion;
}
