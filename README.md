# :polar_bear: `noelware/nixpkgs`
This repository is a Nixpkgs overlay that contains all the packages and services for Noelware's products and services. You can run any Noelware service with this overlay.

<!-- Every package is cached at [`nix.noelware.org`](https://nix.noelware.org), so you can add this to your Nix configuration in `flake.nix` to use the cached version instead of building it yourself:

```nix
{
    nixConfig = {
        extra-substituters = ["https://nix.noelware.org"];
        extra-trusted-public-keys = [ "TODO: this" ];
    };
}
```
-->

## Usage
```nix
{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        noelware-overlay = {
            url = "github:Noelware/nixpkgs-noelware";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, noelware-overlay, ... }: let
        overlays = [(import noelware-overlay)];
        system = "x86_64-linux";

        pkgs = import nixpkgs {
            inherit overlays system;
        };
    in {
        # do whatever with `pkgs` or modify
        # this to your liking
    };
}
```

## License
The code for the services and packages are released under [Unlicense]. You can freely copy and use the code if you want, I don't really care.

[Unlicense]: https://unlicense.org/
[Helm]: https://helm.sh/
