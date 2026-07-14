{ pkgs }:

let
  # Импортируем программы (передаем им pkgs)
  rebuild-wiz = import ./commands-nix/rebuild.nix { inherit pkgs; };
  git-wiz     = import ./git-pull.nix { inherit pkgs; };
  perms-wiz   = import ./restore-perms.nix { inherit pkgs; };
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
