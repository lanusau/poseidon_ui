server "dbutil01qa.lax.qa.untd.com", :app, :web, :db, :primary => true
server "dbutil02qa.lax.qa.untd.com", :app, :web, :db, :primary => true
set :branch, "production"
