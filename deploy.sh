#!/bin/bash -e

# Run once
if [[ $1 == "onetimeinit" ]];
  then
    echo
    echo One-time init

    cd /vagrant/

    # Add 'execute' flag
    chmod +x deploy.sh

    # NPM: update
    #echo
    #echo Updating NPM...
    #sudo npm install -g npm
    #sudo npm install -g grunt-cli

    # Call init
    ./deploy.sh init
fi

# (Re-)Install dependencies
if [[ $1 == "init" ]];
  then
    echo
    echo Installing project dependencies...

    # NPM: Install (package.json)
    #echo
    #echo Installing via NPM...
    #cd /vagrant/htdocs/application/...
    #sudo npm install --no-bin-links

    #cd /vagrant/

    # Composer: Install modules
    echo
    echo 'Installing via Composer (modules)...'
    cd htdocs/modules
    php ../../composer.phar install

    cd /vagrant/
fi

# Refresh composer setup
if [[ $1 == "refresh" ]];
  then
    cd /vagrant/

    echo
    echo Refreshing...

    #rm htdocs/modules/vendor -rf
    echo ...

    ./deploy.sh init
fi

# Refresh database
if [[ $1 == "resetdb" ]];
  then
    cd /vagrant/
    echo
    echo Resetting database...
    echo
    echo Overwriting existing database...
    mysql -uroot -proot oxid < sql/db.sql

    ./deploy.sh
fi

# Prepare OXID eShop project (with OXID Console)
cd /vagrant/

php htdocs/oxid cache:clear
php htdocs/oxid migrate
php htdocs/oxid db:update
php htdocs/oxid config:import
php htdocs/oxid fix:states --all
php htdocs/oxid cache:clear

cd ..

echo
echo --------------------------------
echo 'Preparation done. :-)';
echo Before you commit changes you might want to export config configuration by php oxid config:export 
echo and check or clear the generated configuration files in /web/modules/oxps/modulesconfig/configurations/.
echo
