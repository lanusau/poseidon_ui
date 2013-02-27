# This file has settings that can be used across all applications
#

# Stages
set :stages, %w(dev qa production)
set :default_stage, "dev"
require 'capistrano/ext/multistage'


# GIT configuration
set :scm, :git 
set :branch, "production"

# Deployment configuration
set :deploy_via, :remote_cache
set :bundler_path, "/u01/dba/apps/railsapps/bundler"
set :menu_path, "/u01/dba/apps/railsapps/menu"
set :user, "oracle"
set :group_writable, false
set :normalize_asset_timestamps, false
set :use_sudo, false
set :default_environment, {
  'PATH' => '/u01/dba/apps/ruby-1.9.3/bin:/u01/dba/apps/git/bin:$PATH'
}
set :rake, "bundle exec rake"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# Link to secure copy of database.yml
after "deploy:update_code", "deploy:symlink_db"
namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end


# Check if bundler has all the gems
after "deploy:update_code","deploy:check_bundler"
namespace :deploy do
  desc "Checks if Bundler has all the gems"
  task :check_bundler, :roles => :app do
    on_rollback {  logger.important "Please sync up bundler gems from #{bundler_path} to the target" }
    run "cd #{latest_release} && bundle check --path #{bundler_path}"
  end
end

# Copy menu definitions to global directory
after "deploy:update_code","deploy:copy_menu_definitions"
namespace :deploy do
  desc "Copy menu definitions"
  task :copy_menu_definitions, :roles => :app do
    run "cp #{latest_release}/config/menu/*.yml #{menu_path}/."
  end
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

# This is our default update task
namespace :deploy do
  desc "Deploy application"
  task :default do
    update
    migrate
    restart
  end
end