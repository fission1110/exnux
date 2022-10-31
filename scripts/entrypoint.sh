#!/bin/bash
/usr/lib/postgresql/12/bin/pg_ctl -D /home/$USERNAME/.cache/msf-postgres/ -l /home/$USERNAME/.cache/msf-postgres/postgres.log start
/bin/bash
