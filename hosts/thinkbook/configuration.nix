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

  # Network and internet tools
  qbittorrent

  # Audio and video
  pulseaudio pavucontrol ffmpeg mpv

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
  kdePackages
  lxqt
  policykit
  libnotify
  v4l
  utils
  ydotool
  pciutils
  socat
  cowsay
  ripgrep
  lshw
  bat
  config
  brightnessctl
  virt
  viewe
  swappy
  appimage
  run
  yad
  playerctl
  nh ansible

  # Virtualization
  libvirt

  # File systems
  ntfs3g
  os-prober

  # Downloaders
  yt
  dlp localsend

  # Clipboard managers
  cliphist

  # Fun and customization
  cmatrix
  lolcat
  fastfetch
  onefetch
  microfetch

  # Networking
  networkmanagerapplet

  # Music and streaming
  youtube
  music spotify
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

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs;};
    users.${username} = import ./home.nix;
    backupFileExtension = "backup";
  };

  system.stateVersion = "24.05";
}
