{ pkgs }:

let
  # Импортируем программы (передаем им pkgs)
  rebuild-wiz = import ./nix-commands/maestro_nix-commands.nix { inherit pkgs; };
                       ./niri-commands/maestro_niri-commands.nix { inherit pkgs; };
  kori-menu   = import ./kori-menu.nix { inherit pkgs; };
in
{
  
  # Собираем все импортированные программы в один мета-пакет
  icebook-aliasses-pkgs = pkgs.symlinkJoin {
    name = "icebook-aliasses-pkgs";
    paths = [
      rebuild-wiz
      git-wiz
      perms-wiz
      kori-menu
    ];
  };
}
