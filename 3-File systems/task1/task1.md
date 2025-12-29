# ФС

### 1) Какие файловые системы вы знаете?

- Дисковые: ext4, XFS, Btrfs, NTFS, FAT32, exFAT
- Сетевые: NFS, CIFS/SMB, SSHFS
- Виртуальные: procfs, sysfs, tmpfs, cgroupfs
- Специальные: swap, overlay, squashfs

### 2) Как можно классифиировать файловые системы? в чём отличия??

По назначению:
- Дисковые (постоянное хранение) vs Виртуальные (информация ядра)
- Локальные vs Сетевые
- Журналируемые (ext4) vs Нежурналируемые (FAT32)

Отличия: надёжность, скорость, размер файлов, права доступа, совместимость

### 3) Какие файловые системы используются в linux?

Основные: ext4 (стандарт), XFS (серверы), Btrfs (современная)
- Для /boot: ext2/ext3
- Для /tmp: tmpfs (в памяти)
- Виртуальные: procfs (/proc), sysfs (/sys), devtmpfs (/dev)
- Сетевые: NFS, CIFS для Windows шаринга

### 4) Как можно создать файловую систему на диске?

Найти диск
```
lsblk
```

Создать ФС
```
sudo mkfs.ext4 /dev/sdb1
sudo mkfs.xfs /dev/sdb1
sudo mkfs.ntfs /dev/sdb1
sudo mkfs.vfat /dev/sdb1
```

Проверить
```
sudo blkid /dev/sdb1
```

### 5) Как можно подключить диск в систему, что такое монтирование?

Монтирование - подключение ФС к дереву каталогов

Создать точку монтирования
```
sudo mkdir /mnt/mydisk
```
Смонтировать
```
sudo mount /dev/sdb1 /mnt/mydisk
```
Автомонтирование (/etc/fstab)
```
echo "/dev/sdb1 /mnt/mydisk ext4 defaults 0 2" | sudo tee -a /etc/fstab
```
Размонтировать
```
sudo umount /mnt/mydisk
```

### 6) файловая система procfs, cifs, tpmfs,sysfs. В чём особенности каждой из них? Вывести каталоги к которым примонтированы эти файловые системыю

- procfs (/proc): информация о процессах и системе
- cifs: доступ к Windows/Samba шарингу
- tmpfs: в оперативной памяти
- sysfs (/sys): информация об устройствах

### 7) Как можно получить информацию о системе используя лишь команду cat? вывести ифонмацию о процессоре и состоянии памяти системы


- Дистрибутив: cat /etc/os-release
- Процессор: cat /proc/cpuinfo | grep "model name" | head -1
- Память: cat /proc/meminfo | grep -E "^(MemTotal|MemFree)"
- Нагрузка: cat /proc/loadavg
- Время работы: cat /proc/uptime
- Подключённые swap-устройства: cat /proc/swaps
- Разделы: cat /proc/partitions
