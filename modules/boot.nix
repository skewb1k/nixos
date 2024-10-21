{
  ...
}:

{
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
        default = "saved";
        extraEntries = "GRUB_SAVEDEFAULT=true";
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      timeout = 3;
    };
    plymouth.enable = true;
  };
}