#!/bin/bash

sudo curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.24-linux_x86_64.bash
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3
sudo curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.24-linux_x86_64.bash.sig
gpg --verify snowsql-1.2.24-linux_x86_64.bash.sig snowsql-1.2.24-linux_x86_64.bash
SNOWSQL_DEST=~/bin SNOWSQL_LOGIN_SHELL=~/.profile bash snowsql-1.2.24-linux_x86_64.bash
snowsql -a vc70422.europe-west2.gcp -u RAJESHKANNANE
