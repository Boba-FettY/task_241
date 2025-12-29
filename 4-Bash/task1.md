# Скриптуем по полной

### 1. Что такое шебанг?

Шебанг  - это первые два символа #! в скрипте, которые указывают системе, какой интерпретатор использовать для выполнения скрипта
- #!/bin/bash     # Использовать bash
- #!/bin/sh       # Использовать sh
- #!/usr/bin/python3  # Использовать Python
- #!/usr/bin/env bash # Найти bash в PATH


### 2. Обязательно ли исполняемый файл дожен иметь соотвествующее расширение?

Нет, не обязательно. В Linux расширения не определяют тип файла. Исполняемость определяется:
- Бит исполнения (chmod +x)
- Шебанг в первой строке
- Формат файла (ELF для бинарных, текст для скриптов)

### 3. Напишите скрипт который выполнит автоматически действия из блока работы с файлами. ( не забудьте включить set -euo pipefail для того что бы ваш скрипт было удобнее отлаживать. Опишите что включают эти флаги)

```
#!/bin/bash
```
Безопасные настройки скрипта
```
set -euo pipefail
```

- set -e  - выход при первой ошибке
- set -u  - ошибка при использовании необъявленных переменных
- set -o pipefail  - ошибка если падает любая команда в пайпе

echo "=== НАЧАЛО РАБОТЫ С ФАЙЛАМИ ==="

1. Создаём структуру папок
```
echo "Создаём структуру проекта..."
mkdir -p project/{docs,src,data/{input,output},logs}
```
2. Создаём файлы
```
echo "Создаём тестовые файлы..."
echo "Документация проекта" > project/docs/readme.txt
echo "Исходный код" > project/src/main.py
echo "Входные данные" > project/data/input/data.csv
echo "Выходные данные" > project/data/output/result.txt
echo "Логи" > project/logs/app.log
```
3. Копируем и перемещаем файлы
```
echo "Копируем и перемещаем файлы..."
cp project/docs/readme.txt project/docs/readme_backup.txt
mv project/data/input/data.csv project/data/output/processed_data.csv
```
4. Создаём файлы для сравнения
```
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
```
5. Сравниваем файлы
```
echo "Сравниваем file1.txt и file2.txt..."
if diff file1.txt file2.txt; then
    echo "Файлы идентичны"
else
    echo "Файлы различаются"
fi
```
6. Создаём файл для сортировки
```
echo "Создаём файл для сортировки..."
cat > unsorted.txt << EOF
banana
apple
cherry
date
EOF
```
7. Сортируем
```
echo "Сортировка по возрастанию:"
sort unsorted.txt

echo "Сортировка по убыванию:"
sort -r unsorted.txt
```
8. Показываем структуру
```
echo "Итоговая структура проекта:"
tree project 2>/dev/null || find project -type f | head -10
```
9. Удаляем созданное
```
echo "Очистка..."
rm -rf project file1.txt file2.txt unsorted.txt
```
```
echo "=== СКРИПТ ЗАВЕРШЁН ==="
```
Чтобы заработало
Сохранить как script.sh
```
nano file_operations.sh
```
Дать права на выполнение
```
chmod +x file_operations.sh
```
Запустить
```
./file_operations.sh
```
Или с подробным выводом
```
bash -x file_operations.sh
```