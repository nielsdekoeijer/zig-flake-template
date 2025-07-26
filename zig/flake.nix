{
  description = "YOUR DESCRIPTION HERE";

  inputs = {
    # grab nixpkgs, I use unstable!
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # for 'foreach' system
    utils.url = "github:numtide/flake-utils";

    # grab zig overlay for zig
    zig.url = "github:mitchellh/zig-overlay";

    # put our zig into zls to ensure it matches
    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig-overlay.follows = "zig";
    };
  };

  outputs = { self, nixpkgs, utils, zig, zls }:
    utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ] (system:
      let

        # packages for the given system
        pkgs = import nixpkgs {
          inherit system;
          # use overlays
          overlays = [
            (final: prev: {
              zig = zig.packages.${system}."master";
              zls = zls.packages.${system}.default;
            })
          ];
        };
      in {
        # on `nix develop`
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.zig pkgs.zls ];

          # puts a nice hook, I like this
          shellHook = ''
            PS1="(dev) $PS1"
          '';
        };
      });
}
