{ config, pkgs, inputs, ... }:

# let
#   nur-pkgs = import (builtins.fetchTarball  {
#     url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
#     sha256 = "0b3xg1b7v14bkmhpjp56f0j7ghjmb25mq4m7qjawwdyyk67ys22p";
#   }) {};

# in
let
  nurNoPkgs = import inputs.nur { pkgs = null; nurpkgs = pkgs; };
in
{
  imports = [
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/helix.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "acrease";
  home.homeDirectory = "/home/acrease";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.discord
    pkgs.zoxide
    pkgs.fzf

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "rebuild" ''
      git -C ~/.config/nixos/ add .
      git -C ~/.config/nixos/ commit
      sudo nixos-rebuild switch --flake ~/.config/nixos#default && \
      git -C ~/.config/nixos/ push
    '')
  ];

  programs.ncspot = {
    enable = true;
    settings = {}; # toml config file
  };

  programs.firefox = {
    enable = true;
    profiles.acrease = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        vimium-c
        dashlane
        darkreader
      ];
    };
  };
  
  programs.wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      "$menu" = "rofi --show drun ssh";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      input = {
        kb_layout = "gb";
      };


      bind = [
        "$mod, r, exec, rofi -show drun ssh"
      ];
  };
  programs.hyprlock.enable = true;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = [];
    settings = {
      theme = "kanagawa";
      editor = {
        rulers = [80 120];
        line-number = "relative";
        bufferline = "multiple";
        cursorline = true;
        cursorcolumn = true;
        file-picker.hidden = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        lsp = {
          auto-signature-help = false;
          display-messages = false;
        };
        statusline = {
          left = ["mode" "spinner" "version-control" "file-name"];
        };
      };
      keys.normal = {
        "A-," = "goto_previous_buffer";
        "A-." = "goto_next_buffer";
        "A-w" = ":buffer-close";
      };
      keys.insert = {
        j = { k = "normal_mode"; };
      };
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
    };
  };
  
  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "alex@crease.sh";
    userName = "acrease";
  };

  programs.lazygit = {
    enable = true;
    settings = {};
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/acrease/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "hx";
    config = "~/.config/nixos/";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
