#!/bin/bash
set -e

# full repro on Ubuntu 16.04

sudo apt-get -qq update
sudo apt-get -qq install -y lsb-release software-properties-common wget curl vim htop git byobu libcurl4-openssl-dev libssl-dev libfontconfig1-dev libfribidi-dev libxml2-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libharfbuzz-dev libgit2-dev
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/"
sudo apt-get -qq update
sudo apt-get -qq install -y r-base-dev virtualenv

cd /usr/local/lib/R
sudo chmod o+w site-library

cd ~
mkdir -p .R
echo 'CFLAGS=-O3 -mtune=native' >> ~/.R/Makevars
echo 'CXXFLAGS=-O3 -mtune=native' >> ~/.R/Makevars


Rscript -e 'install.packages(c("jsonlite","bit64","devtools","rmarkdown"), repos="https://cloud.r-project.org")'


# install dplyr

Rscript -e 'devtools::install_github(c("tidyverse/readr","tidyverse/dplyr"))'

# install data.table
Rscript -e 'install.packages("data.table")'

# benchmark
cd db-benchmark
mkdir data

# generate data for groupby
Rscript _data/groupby-datagen.R 1e7 1e2 0 0
Rscript _data/groupby-datagen.R 1e8 1e2 0 0
#Rscript _data/groupby-datagen.R 1e9 1e2 0 0

mv G1_1e7_1e2_0_0.csv ~/git/db-benchmark/data
mv G1_1e8_1e2_0_0.csv ~/git/db-benchmark/data

#clickhouse Installation
sudo apt-get install -y apt-transport-https ca-certificates dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8919F6BD2B48D754

echo "deb https://packages.clickhouse.com/deb stable main" | sudo tee \
    /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update

sudo apt-get install -y clickhouse-server clickhouse-client

sudo rm /var/log/clickhouse-server/clickhouse-server.err.log /var/log/clickhouse-server/clickhouse-server.log
# sudo apt purge -y clickhouse-server
# sudo apt purge -y clickhouse-client
# sudo apt -y autoremove
# sudo rm -rf .../clickhouse*
# sudo rm -rf /etc/clickhouse-server


sudo grep '<user_files_path>/var/lib/clickhouse/user_files/</user_files_path>' /etc/clickhouse-server/config.xml
sudo sed -i -e "s|<user_files_path>/var/lib/clickhouse/user_files/</user_files_path>|<user_files_path>`pwd`/</user_files_path>|" /etc/clickhouse-server/config.xml
sudo chown clickhouse:clickhouse clickhouse/
sudo chmod 755 clickhouse/

sudo service clickhouse-server start

./_launcher/solution.R --solution=data.table --task=groupby --nrow=1e7


