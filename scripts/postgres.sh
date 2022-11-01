#!/bin/bash
MSF_POSTGRES=/home/postgres/msf-postgres
POSTGRES_USER=postgres
POSTGRES_PATH=/usr/lib/postgresql/12/bin

sudo mkdir -p $MSF_POSTGRES
sudo chown $POSTGRES_USER:$POSTGRES_USER $MSF_POSTGRES
sudo -u postgres $POSTGRES_PATH/initdb $MSF_POSTGRES
sudo -u postgres /bin/bash -c 'echo "port = 9999" >> $MSF_POSTGRES/postgresql.conf'
sudo mkdir -p /var/run/postgresql
sudo chown $POSTGRES_USER:$POSTGRES_USER /var/run/postgresql
sudo -u $POSTGRES_USER $POSTGRES_PATH/pg_ctl -D $MSF_POSTGRES -l $MSF_POSTGRES/postgres.log start
# wait for postgres to start
sleep 5
# create msf database
sudo -u $POSTGRES_USER $POSTGRES_PATH/createdb -h localhost -p 9999 msf
# create msf user
echo "create user msf with encrypted password 'msf';" | sudo -u $POSTGRES_USER $POSTGRES_PATH/psql -h localhost -p 9999 msf
echo "grant all privileges on database msf to msf;" | sudo -u $POSTGRES_USER $POSTGRES_PATH/psql -h localhost -p 9999 msf
