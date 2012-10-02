# Poseidon UI - RPM install

This is a Rails 3.2 application to provide web based UI for Poseidon database monitoring server. 

## Requirements 

* Ruby 1.9.2 or later rpm. Rails 3.2 does support Ruby 1.8.7, so it may work as well, but application was tested on 1.9.2 only
* rubygems rpm
* rubygem-passenger
* Apache 2.2 or later
* Oracle instant client - basic
* Mysql client  - shared
* Postgres client - libs

## Installation

Install rpm. Application will be installed in following directories:

  /usr/local/railsapps/poseidon_ui - application files
  /etc/railsapps/poseidon_ui - configuration
  /var/log/railsapps/poseidon_ui - log files
  /var/cache/railsapps/poseidon_ui - temporary files

## Setup

### Setup MySQL database and user

MySQL database can be local or remote. Any 5.x version should work. 

	create database <db_name>;
	grant all on <db_name>.* to <app_user>@'%' identified by '***';

### Setup configuration file

Go to `/etc/railsapps/poseidon_ui` and copy provided `database.yml.example` to `database.yml`. Edit `database.yml` and update fields with MySQL hostname, database name and user name/password. Change secret which will be used as encryption/decryption key for sensitive data in tables. 

### Create schema objects

Execute:

	bundle exec rake db:setup RAILS_ENV=production

This will connect to the database specified in `database.yml` and create repository schema objects.

## Deployment

The rubygem-passenger rpm should already put configuration file in /etc/httpd/conf.d/passenger.conf. So all is needed is to setup virtual server in main Apache configuration file, similar to this:

<VirtualHost *:3000>
  DocumentRoot /usr/local/railsapps
  RewriteEngine On
  RewriteRule ^/$ /monitoring/ [R,L]
  <Directory /usr/local/railsapps>
    # This relaxes Apache security settings.
    AllowOverride all
    Options -MultiViews
  </Directory>
  RailsBaseURI /monitoring
</VirtualHost>
