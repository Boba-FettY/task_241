#!/bin/bash

# Безопасные настройки скрипта
set -euo pipefail

# set -e  - выход при первой ошибке
# set -u  - ошибка при использовании необъявленных переменных
# set -o pipefail  - ошибка если падает любая команда в пайпе

echo "=== НАЧАЛО РАБОТЫ С ФАЙЛАМИ ==="

# 1. Создаём структуру папок
echo "Создаём структуру проекта..."
mkdir -p project/{docs,src,data/{input,output},logs}

# 2. Создаём файлы
echo "Создаём тестовые файлы..."
echo "Документация проекта" > project/docs/readme.txt
echo "Исходный код" > project/src/main.py
echo "Входные данные" > project/data/input/data.csv
echo "Выходные данные" > project/data/output/result.txt
echo "Логи" > project/logs/app.log

# 3. Копируем и перемещаем файлы
echo "Копируем и перемещаем файлы..."
cp project/docs/readme.txt project/docs/readme_backup.txt
mv project/data/input/data.csv project/data/output/processed_data.csv

# 4. Создаём файлы для сравнения
echo "Создаём файлы для сравнения..."
cat > file1.txt << EOF
Строка 1
Строка 2
Строка 3
EOF

cat > file2.txt << EOF
Строка 1
Строка 3
Строка 4
EOF

# 5. Сравниваем файлы
echo "Сравниваем file1.txt и file2.txt..."
if diff file1.txt file2.txt; then
    echo "Файлы идентичны"
else
    echo "Файлы различаются"
fi

# 6. Создаём файл для сортировки
echo "Создаём файл для сортировки..."
cat > unsorted.txt << EOF
banana
apple
cherry
date
EOF

# 7. Сортируем
echo "Сортировка по возрастанию:"
sort unsorted.txt

echo "Сортировка по убыванию:"
sort -r unsorted.txt

# 8. Показываем структуру
echo "Итоговая структура проекта:"
tree project 2>/dev/null || find project -type f | head -10

# 9. Удаляем созданное (закомментировано для проверки)
# echo "Очистка..."
# rm -rf project file1.txt file2.txt unsorted.txt

echo "=== СКРИПТ ЗАВЕРШЁН ==="
