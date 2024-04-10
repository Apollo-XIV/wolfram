{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprlock.url = "github:hyprwm/Hyprlock";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprlock, nur, ... }@inputs: {
    # homeConfigurations."acrease" = home-manager.lib.homeManagerConfiguration {
    #   pkgs = nixpkgs.legacyPackages.x86_64-linux;

        # {wayland.windowManager.hyprland.enable = true;}
    #   modules = [
    #     hyprland.homeManagerModules.default
    #     {wayland.windowManager.hyprland.enable = true;}
    #     # ...
    #   ];
    # };
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.home-manager.nixosModules.default
        nur.nixosModules.nur
        ({pkgs, ...}: {
          nixpkgs.overlays = [nur.overlay];
          imports = [
            ./hosts/default/configuration.nix
          ];
        })    
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.acrease = {
            imports = [
              hyprlock.homeManagerModules.hyprlock
            ];
          };
        }
      ];
    };
  };
}
