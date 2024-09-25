{
  pkgs,
  inputs,
  options,
  user,
  stateVersion,
  hostName,
  ...
}:

{
  imports = [
    # ./hardware-configuration.nix
    <nixos-wsl/modules>
    ../../modules/nix.nix
    # ../../modules/boot.nix
    # ../../modules/flatpak.nix
    ../../modules/security.nix
    ../../modules/zsh/module.nix
    ../../modules/htop/module.nix
    ../../modules/nvim/module.nix
    # ../../modules/alacritty/module.nix
    ../../modules/nh.nix
    ../../modules/git.nix
    # ../../modules/gnupg.nix
    # ../../modules/bluetooth.nix
    ../../modules/virt.nix
    # ../../modules/waybar/module.nix
    # ../../modules/hypr/module.nix
  ];
  wsl.enable = true;
  wsl.defaultUser = user;

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
    hostName = hostName;
    networkmanager.enable = true;
    # timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  };

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    vim
    neovide

    # Version control and development tools
    lazydocker
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

    # Fun and customization
    cmatrix
    fastfetch

    # Networking
    networkmanagerapplet
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
