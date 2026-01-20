{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.${system}.default =
        let
          libs = with pkgs; [
            xmlsec
            zlib
            openldap
            libidn
            libxml2
            sqlite
            libpq
            libyaml
            curl
            glibc
            shared-mime-info
            libtool
          ];
        in
        pkgs.mkShell {
          name = "devenv";
          buildInputs = libs;
          nativeBuildInputs = with pkgs; [
            ruby_3_4
            bundler
            gcc
            gnumake
            postgresql_14
            dpkg
            pkg-config
            shared-mime-info
          ];

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath libs}:$LD_LIBRARY_PATH";
          FREEDESKTOP_MIME_TYPES_PATH = "${pkgs.shared-mime-info}/share/mime/packages/freedesktop.org.xml";

          shellHook = ''
            echo "Devshell activated."
          '';
        };
    };
}
