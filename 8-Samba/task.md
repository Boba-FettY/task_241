
# Шарим

### 1. Установите пакет samba

```
sudo apt-get install samba samba-client
```

### 2. ЧТо такое побщая папка, зачем оно может быть нужно?

Общая папка - директория, доступная по сети для других компьютеров. Используется для:
- Обмена файлами между Linux и Windows
- Сетевого хранилища
- Резервного копирования
- Совместной работы над документами

### 3. Создайте общую папку без пароля с правами только на чтение файлов

Создаём папку
```
sudo mkdir -p /srv/share_public
sudo chmod 755 /srv/share_public
```
Редактируем конфиг Samba
```
sudo vi /etc/samba/smb.conf
```
Добавляем в конец:
```
[public]
    comment = Public Share
    path = /srv/share_public
    browseable = yes
    read only = yes
    guest ok = yes
    create mask = 0644
```

### 4. Создайте общую папку с паролем с правами на чтение и запись

Создаём папку
```
sudo mkdir -p /srv/share_private
sudo chmod 770 /srv/share_private
```

Добавляем в smb.conf:
```
[private]
    comment = Private Share
    path = /srv/share_private
    browseable = yes
    read only = no
    guest ok = no
    valid users = @smbusers
    create mask = 0660
    directory mask = 0770
```
Создаём группу и пользователя
```
sudo groupadd smbusers
sudo useradd sambauser
sudo smbpasswd -a sambauser
sudo usermod -aG smbusers sambauser
```

### 5. Создайте общую папку с доступом для какой-то группы с полными правами

Создаём группу
```
sudo groupadd fullaccess
```

Создаём папку
```
sudo mkdir -p /srv/share_group
sudo chgrp fullaccess /srv/share_group
sudo chmod 770 /srv/share_group
```
Добавляем в smb.conf:
```
[group_share]
    comment = Group Share
    path = /srv/share_group
    browseable = yes
    read only = no
    guest ok = no
    valid users = @fullaccess
    create mask = 0770
    directory mask = 0770
```

### 6. Создайте общую папку в которой у одной группы будет полный доступ, а у другой только доступ на чтение. Третья группа не должна иметь к ней доступа

Создаём группы
```
sudo groupadd admin_group
sudo groupadd user_group
sudo groupadd denied_group
```
Создаём папку
```
sudo mkdir -p /srv/share_mixed
sudo chgrp admin_group /srv/share_mixed
sudo chmod 775 /srv/share_mixed
```
Добавляем в smb.conf:
```
[mixed_share]
    comment = Mixed Access Share
    path = /srv/share_mixed
    browseable = yes
    read only = no
    guest ok = no
    valid users = @admin_group, @user_group
    invalid users = @denied_group
    write list = @admin_group
    read list = @user_group
    create mask = 0775
    directory mask = 0775
```
