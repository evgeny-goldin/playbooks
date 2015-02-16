UPDATE mysql.user SET Password=PASSWORD('{{ mysql.root.password }}') WHERE User='{{ mysql.root.user }}';
GRANT ALL PRIVILEGES ON *.* TO '{{ mysql.root.user }}'@'%';
FLUSH PRIVILEGES;
