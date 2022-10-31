#!/bin/bash
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" mkdir -p /home/$USERNAME/.cache/msf-postgres
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" /usr/lib/postgresql/12/bin/initdb /home/$USERNAME/.cache/msf-postgres/
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" # change postgres username and password to "msf" and "msf" respectively
echo "port = 9999" >> /home/$USERNAME/.cache/msf-postgres/postgresql.conf
mkdir -p /var/run/postgresql
chown $USERNAME:$USERNAME /var/run/postgresql
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" /usr/lib/postgresql/12/bin/pg_ctl -D /home/$USERNAME/.cache/msf-postgres/ -l /home/$USERNAME/.cache/msf-postgres/postgres.log start
# wait for postgres to start
sleep 5
# create msf database
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" /usr/lib/postgresql/12/bin/createdb -h localhost -p 9999 msf
# create msf user
echo "create user msf with encrypted password 'msf';" | /usr/lib/postgresql/12/bin/psql -h localhost -p 9999  msf
echo "grant all privileges on database msf to msf;" | /usr/lib/postgresql/12/bin/psql -h localhost -p 9999 msf
# stop postgres
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" /usr/lib/postgresql/12/bin/pg_ctl -D /home/$USERNAME/.cache/msf-postgres/ -l /home/$USERNAME/.cache/msf-postgres/postgres.log stop
