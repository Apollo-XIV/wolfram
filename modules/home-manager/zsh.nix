{ lib, config, pkgs, ... }:

{

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      highlight = null;
    };
    defaultKeymap = "viins";
    dirHashes = {
      config = "$HOME/.config/nixos";
    };
    initExtra = ''
      eval "$(starship init zsh)"
    ''

  };
}
