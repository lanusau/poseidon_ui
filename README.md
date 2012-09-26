# Poseidon UI

This is a Rails 3.2 application to provide web based UI for Poseidon database monitoring server. 

## Requirements 

* Ruby 1.9.2 or later. Rails 3.2 does support Ruby 1.8.7, so it may work as well, but application was tested on 1.9.2 only
* Ruby gems
* Bundler gem
* Oracle instant client - basic and devel
* Mysql client  - shared and devel
* Postgres client - libs and devel

The gem requirements are specified in Gemfile and can be installed using bundler

	bundle install

You most likely will need to set `LD_LIBRARY_PATH` to Oracle instant client libraries to install ruby-oci8 gem

	LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib
	export LD_LIBRARY_PATH

## Setup

### Download the application

Download application from github:

	git clone https://github.com/lanusau/poseidon_ui.git

### Setup database and user

	create database <db_name>;
	grant all on <db_name>.* to <app_user>@'%' identified by '***';

### Create tables

Go to the directory where application was downloaded. Create file config/database.yml with database information:

    production:
      adapter: mysql2
      encoding: utf8
      reconnect: false
      database: <db_name>
      pool: 5
      username: <app_user>
      password: ****
      host: <host name where mysql is running>

Then create schema objects:

	bundle exec rake db:setup RAILS_ENV=production

## Deployment

The easiest way to launch application is to use Rails built in server

	bundle exec rails server RALS_ENV=production

However, for production, you may want to use Apache or Nginx. Please see documentation above on how to configure other webservers:

[http://rubyonrails.org/deploy](http://rubyonrails.org/deploy)
