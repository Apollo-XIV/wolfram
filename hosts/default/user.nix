{ lib, config, pkgs, ... }:

{

  options = {
    user.enable = lib.mkEnableOption "enable user module";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  config = lib.mkIf config.user.enable {
    users.users.acrease = {
      isNormalUser = true;
      description = "Alex Crease";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        firefox
      #  thunderbird
      ];
    };
  };
}
