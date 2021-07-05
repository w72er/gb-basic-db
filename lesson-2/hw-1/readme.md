# Задание 1 

Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf,
задав в нем логин и пароль, который указывался при установке.

## Решение

### Установка mysql-server

Чтобы были доступны пакеты, например `mysql-workbench-community` подключим
репозиторий `mysql`. Для этого выполним пункт `Go to the download page for the MySQL APT repository at https://dev.mysql.com/downloads/repo/apt/.`
из [официальной документации](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/),
то есть скопируем пакет на жесткий, установим его и обновим список репозиториев.
```shell
sudo dpkg -i ~/Загрузки/mysql-apt-config_0.8.17-1_all.deb
# mysql server and cluster -> mysql-8.0
# они все выставлены в дефолты, можно просто нажать на OK.
sudo apt update
sudo apt install mysql # tab, tab:
# mysql-apt-config                       mysql-connector-odbc-dbgsym
# mysql-community-test-debug             mysql-workbench-community
# ...
```

Чтобы подключаться без использования `sudo` перед командой `mysql` следует
при установке пакета `mysql-server` использовать опцию `Use Legacy Authentication Method`,
подробнее [здесь](https://askubuntu.com/questions/763336/cannot-enter-phpmyadmin-as-root-mysql-5-7).
При установке сервера, автоматически установится и клиент:
```text
sudo apt install mysql-server
```

### Установка my.cnf

[my.cnf location](https://stackoverflow.com/questions/2482234/how-do-i-find-the-mysql-my-cnf-location) =>
`~/.my.cnf`.

Сделаем ссылку, так я не забуду почистить файл после прохождения проекта.
```shell
ln -s /home/a/projects/my/gb-basic-db/lesson-2/hw-1/.my.cnf ~/
```

## Результат

```text
a@md:~$ mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.25 MySQL Community Server - GPL

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
