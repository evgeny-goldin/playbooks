#/bin/bash

# http://txt.fliglio.com/2013/11/creating-a-mysql-docker-container/

if [ ! -f /var/lib/mysql/ibdata1 ]; then
    /usr/bin/mysql_install_db
    /usr/bin/mysqld_safe &
    sleep 10
    echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;" | mysql
    killall mysqld
    sleep 10
fi

/usr/bin/mysqld_safe
