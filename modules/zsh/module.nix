{...}:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases =
      let
        flakeDir = "~/nixos";
      in {
      rb = "sudo nixos-rebuild switch --flake ${flakeDir}";
      upd = "sudo nix flake update ${flakeDir}";
      upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";
      scg = "sudo nix-collect-garbage -d";
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
}