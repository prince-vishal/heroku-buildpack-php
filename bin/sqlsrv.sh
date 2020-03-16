#!/usr/bin/env bash
# Build Path: /app/.heroku/php/
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
sudo ACCEPT_EULA=Y apt-get install msodbcsql17
sudo ACCEPT_EULA=Y apt-get install mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
sudo apt-get install unixodbc-dev
sudo pecl install sqlsrv
sudo pecl install pdo_sqlsrv

BUILD_DIR=$1
ln -s $BUILD_DIR/.heroku /app/.heroku
export PATH=/app/.heroku/php/bin:$PATH
bash ./install
cd

printf "; priority=20\nextension=sqlsrv.so\n" > /app/.heroku/php/etc/php/7.3/mods-available/sqlsrv.ini
printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /app/.heroku/php/etc/php/7.3/mods-available/pdo_sqlsrv.ini
sudo phpenmod -v 7.3 sqlsrv pdo_sqlsrv
