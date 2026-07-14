{
  description = "Kori's custom shell tools and wizards bundle";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Импортируем ОДИН единственный файл-оркестратор
      maestro = import ./commands-nix/maestro_commands.nix { inherit pkgs; };
    in
    {
      packages.${system} = rec {
        # Экспортируем бандл, который собрал маэстро
        icebook-aliasses-pkgs = maestro.icebook-aliasses-pkgs;

        # По умолчанию отдаем его же
        default = icebook-aliasses-pkgs;
      };
    };
}
