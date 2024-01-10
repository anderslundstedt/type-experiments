{
  description = "some experiments with type systems";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {self, nixpkgs, flake-utils}:
    flake-utils.lib.eachSystem
      ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"]
      (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          commonPkgs = [
            pkgs.bashInteractive
            pkgs.gnumake
          ];
          pythonPkgs = [
            pkgs.python312
            pkgs.pyright
          ];
          coqPkgs = [
            pkgs.coq_8_16
          ];
          githubPkgs = [
            pkgs.python311Packages.grip # for local GitHub README.md preview
          ];
        in
        {
          devShells.default = pkgs.mkShell {
            packages = commonPkgs ++ pythonPkgs ++ coqPkgs ++ githubPkgs;
          };
          devShells.python = pkgs.mkShell {
            packages = commonPkgs ++ pythonPkgs;
          };
          devShells.coq = pkgs.mkShell {
            packages = commonPkgs ++ coqPkgs;
          };
          devShells.github = pkgs.mkShell {
            packages = githubPkgs;
          };
        }
     );
}
