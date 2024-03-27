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
  };

  outputs = { self, nixpkgs, home-manager, hyprlock, nur, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ({pkgs, ...}: {
          nixpkgs.overlays = [nur.overlay];
          imports = [
            ./hosts/default/configuration.nix
          ];
        })          
        inputs.home-manager.nixosModules.default
        nur.nixosModules.nur
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
