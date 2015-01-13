server "dbutil01vgs.vgs.untd.com", :app, :web, :db, :primary => true
server "dbutil01dca.dca.untd.com", :app, :web, :db, :primary => false
set :branch, "production"
