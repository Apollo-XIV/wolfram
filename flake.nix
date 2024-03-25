{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprlock.url = "github:hyprwm/Hyprlock";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprlock, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/default/configuration.nix
        hyprlock
        inputs.home-manager.nixosModules.default
        {
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
