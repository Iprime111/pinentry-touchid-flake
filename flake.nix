{
  description = "Pinentry-touchid custom flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      version = "v0.0.3";
      sha256 = "0wkppmlq4795xpikmcjalsmy12d9519ph0p4x9gf8v435sh2873g"; 
    in {
      packages.${system} = {
        pinentry-touchid = pkgs.stdenv.mkDerivation {
          pname = "pinentry-touchid";
          inherit version;

          nativeBuildInputs = with pkgs; [
            gnutar
          ];

          propagatedBuildInputs = with pkgs; [
            pinentry_mac
            gnupg
          ];

          src = pkgs.fetchurl {
            url = "https://github.com/jorgelbg/pinentry-touchid/releases/download/${version}/pinentry-touchid_0.0.3_macos_arm64.tar.gz";
            inherit sha256;
          };

          unpackPhase = ''
            mkdir -p unpack_dir
            tar -xzf $src -C unpack_dir
          '';

          installPhase = ''
            install -D -m755 unpack_dir/pinentry-touchid $out/bin/pinentry-touchid
          '';

          meta = with pkgs.lib; {
            description = "TouchId version of pinentry-mac";
            homepage = "https://github.com/jorgelbg/pinentry-touchid";
            license = licenses.asl20;
            platforms = [ "aarch64-darwin" ];
          };
        };

        default = self.packages.${system}.pinentry-touchid;
      };
    };
}
