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
      eval "$(zoxide init zsh --cmd cd)"
      eval "$(starship init zsh)"
    '';

    shellAliases = {
      tree = "eza --tree --icons --group-directories-first";
      ls = "eza -ahl --icons --group-directories-first"
    };

    syntaxHighlighting = {
      enable = true;
      
    };
  };
}
