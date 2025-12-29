# Пишем юниты

### 1. Создайте скрипт который создаёт папку заполняет её файлами ( имена 1-4 ) и записывает в них информацию
о текущей дате, версии ядра, имени компьютера и списе всех файлов в домашнем каталоге пользователя от которого выполняется скрипт( не забудьте сдлеать проверку на существование файлов и папок)

```
#!/bin/bash
set -euo pipefail

# Функция проверки существования
check_exists() {
    if [ ! -e "$1" ]; then
        echo "Создаём: $1"
        return 1
    fi
    return 0
}

# Работаем из домашней папки вызывающего
cd ~

# Создаём папку
FOLDER="system_info_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$FOLDER"

# Создаём файлы с информацией
for i in {1..4}; do
    FILE="$FOLDER/file$i.txt"
    
    cat > "$FILE" << EOF
=== ИНФОРМАЦИЯ О СИСТЕМЕ ===
Дата: $(date)
Версия ядра: $(uname -r)
Имя компьютера: $(hostname)
Пользователь: $(whoami)

=== ФАЙЛЫ В ДОМАШНЕЙ ПАПКЕ ===
$(ls -la ~/ | head -20)
EOF
    
    echo "Создан файл: $FILE"
done

echo "Скрипт выполнен успешно!"
```
Сохранить: ```/home/jmak/system_info.sh```
Права: ```chmod +x /home/jmak/system_info.sh```


### 2. Создайте юнит который будет вызывать этот скрипт при запуске. Проверьте

```
sudo tee /etc/systemd/system/info.service << 'EOF'
[Unit]
Description=Сбор системной информации
After=network.target

[Service]
Type=oneshot
ExecStart=/home/jmak/system_info.sh
User=jmak
WorkingDirectory=/home/jmak

[Install]
WantedBy=multi-user.target
EOF
```
Проверка:
```
sudo systemctl daemon-reload
sudo systemctl start info.service
sudo systemctl status info.service
ls ~/system_info_*
```

### 3. Создайте таймер который будет вызывать выполнение одноимённого systemd юнита каждые 5 минут.

```
sudo tee /etc/systemd/system/info.timer << 'EOF'
[Unit]
Description=Таймер сбора информации каждые 5 минут

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
EOF
```
Запуск:
```
sudo systemctl daemon-reload
sudo systemctl enable info.timer
sudo systemctl start info.timer
systemctl list-timers | grep info
```

### 4. От какого пользователя вызыаются юниты поумолчанию?

root (системные) или пользователь (user юниты в ~/.config/systemd/user/)

### 5. Создайте пользователя от имени которого будет выполняться ваш скрипт.

```
sudo useradd -m -s /bin/bash scriptuser
```
Установка парля
```
sudo passwd scriptuser 
```

### 6. Дополните юнит информацией о пользователе от которого должен выплняться скрипт.

```
sudo tee /etc/systemd/system/info.service << 'EOF'
[Unit]
Description=Сбор системной информации
After=network.target

[Service]
Type=oneshot
ExecStart=/home/jmak/system_info.sh
User=scriptuser
Group=scriptuser
WorkingDirectory=/home/scriptuser

[Install]
WantedBy=multi-user.target
EOF
```

### 7. Дополните ваш скрипт так, что бы он независимо от местоположения всега выполнялся в домашней папке того кто его вызывает.
Итог:
```
#!/bin/bash
set -euo pipefail

cd ~  # Всегда из домашней папки

FOLDER="system_info_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$FOLDER"

for i in {1..4}; do
    cat > "$FOLDER/file$i.txt" << EOF
Дата: $(date)
Ядро: $(uname -r)
Хост: $(hostname)
Пользователь: $(whoami)
Домашняя папка: $HOME

Файлы в домашней:
$(ls -la ~ | head -15)
EOF
done

echo "Информация сохранена в ~/$FOLDER/"
```
