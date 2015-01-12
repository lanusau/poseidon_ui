server "dbutil01qa.vgs.qa.untd.com", :app, :web, :db, :primary => true
server "dbutil02qa.vgs.qa.untd.com", :app, :web, :db, :primary => true
set :branch, "production"
