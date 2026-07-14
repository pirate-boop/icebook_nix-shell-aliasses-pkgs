{ pkgs }:

pkgs.writeShellScriptBin "kori-rebuild" ''
  clear
  echo "========================================="
  echo "       KORI NIXOS DEPLOYMENT WIZARD      "
  echo "========================================="
  echo ""

  FINAL_CMD="sudo nixos-rebuild switch --flake .#Kori-Icebook"

  # EVENT 1: Проверка логов ошибок
  echo "1) Нужен подробный вывод ошибок (--show-trace)?"
  echo "  1. Да"
  echo "  2. Нет"
  read -p "Выбор (1-2): " trace_choice
  if [ "$trace_choice" = "1" ]; then
      FINAL_CMD="$FINAL_CMD --show-trace"
  fi
  echo ""

  # EVENT 2: Защита оперативной памяти
  echo "2) Ограничить количество потоков (--max-jobs)?"
  echo "  1. Да, жестко в 1 поток (Безопасно)"
  echo "  2. Да, ввести количество вручную"
  echo "  3. Нет (Использовать дефолт)"
  read -p "Выбор (1-3): " job_choice
  if [ "$job_choice" = "1" ]; then
      FINAL_CMD="$FINAL_CMD --max-jobs 1"
  elif [ "$job_choice" = "2" ]; then
      read -p "Укажите количество jobs: " job_count
      FINAL_CMD="$FINAL_CMD --max-jobs $job_count"
  fi
  echo ""

  # EVENT 3: Сохранение логов в файл (Портативно через $HOME)
  echo "3) Дублировать вывод сборки в лог-файл?"
  echo "  1. Да, в папку Загрузки (~/Downloads)"
  echo "  2. Да, в папку Документы (~/Documents)"
  echo "  3. Нет"
  read -p "Выбор (1-3): " log_choice
  if [ "$log_choice" = "1" ]; then
      FINAL_CMD="$FINAL_CMD 2>&1 | tee \$HOME/Downloads/nixos-switch.log"
  elif [ "$log_choice" = "2" ]; then
      FINAL_CMD="$FINAL_CMD 2>&1 | tee \$HOME/Documents/nixos-switch.log"
  fi
  echo ""

  # EVENT 4: Старт
  echo "-----------------------------------------"
  echo "Сформированная команда:"
  echo ">> $FINAL_CMD"
  echo "-----------------------------------------"
  echo "1. START (Запустить справа)"
  echo "2. BREAK (Отмена)"
  read -p "Действие (1-2): " final_action

  if [ "$final_action" = "1" ]; then
      echo "Разделяю экран..."
      RIGHT_PANE=$(wezterm cli split-pane --right --percent 50)
      wezterm cli send-text --pane-id "$RIGHT_PANE" "$FINAL_CMD; echo; echo '=== Сборка завершена ==='; read"
  else
      echo "Отменено."
      exit 0
  fi
''
