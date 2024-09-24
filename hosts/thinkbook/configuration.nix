{
  inputs,
  lib,
  pkgs,
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
    ../../modules/waybar/module.nix
    ../../modules/hypr/module.nix
    ../../modules/gnupg.nix
    ../../modules/bluetooth.nix
    ../../modules/virt.nix
  ];

  networking = {
    hostName = "thinkbook";
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  };

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

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
    gh
    # lazygit
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
    git.enable = true;
    lazygit.enable = true;
    htop.enable = true;
    nix-ld.enable = true;
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
      extraPackages = with pkgs; [
        amdvlk
      ];
      package = pkgs.mesa.drivers;
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

  system.stateVersion = stateVersion;
}
