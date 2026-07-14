{ pkgs }:

pkgs.writeShellScriptBin "kori-git" ''
  clear
  echo "========================================="
  echo "             KORI GIT WIZARD             "
  echo "========================================="
  echo ""

  # EVENT 1: Выбор действия
  echo "1) Что делаем с репозиторием?"
  echo "  1. Pull (Стянуть изменения извне)"
  echo "  2. Push (Отправить локальные изменения)"
  echo "  3. Status (Проверить статус)"
  read -p "Выбор (1-3): " git_action

  CMD=""
  case "$git_action" in
      1) CMD="git pull" ;;
      2) 
         read -p "Введите сообщение коммита: " commit_msg
         CMD="git add . && git commit -m \"$commit_msg\" && git push" 
         ;;
      3) CMD="git status" ;;
      *) echo "Отмена."; exit 0 ;;
  esac
  echo ""

  # EVENT 2: Выбор директории (Портативно)
  echo "2) В каком репозитории запустить?"
  echo "  1. В текущей директории (\$PWD)"
  echo "  2. В папке конфигурации NixOS (/etc/nixos)"
  read -p "Выбор (1-2): " path_choice

  RUN_PATH="\$PWD"
  if [ "$path_choice" = "2" ]; then
      RUN_PATH="/etc/nixos"
  fi

  FINAL_CMD="cd $RUN_PATH && $CMD"

  # EVENT 3: Финальное подтверждение
  echo "-----------------------------------------"
  echo "Команда: $FINAL_CMD"
  echo "-----------------------------------------"
  echo "1. START (Запустить в правой панели)"
  echo "2. BREAK (Отмена)"
  read -p "Действие (1-2): " final_action

  if [ "$final_action" = "1" ]; then
      RIGHT_PANE=$(wezterm cli split-pane --right --percent 50)
      wezterm cli send-text --pane-id "$RIGHT_PANE" "$FINAL_CMD; echo; echo '=== Git-операция завершена ==='; read"
  else
      echo "Отменено."
  fi
''
