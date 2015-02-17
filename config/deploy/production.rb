require 'resolv'

# Database migrations will only run on primary host
@primary_host = Resolv.getname(Resolv.new.getaddress('dbutil.prod.untd.com'))

# Set primary flag if server name matches primary server name
def server_with_primary_flag(server_name)
  server server_name, :app, :web, :db, :primary => (@primary_host == server_name)
end

server_with_primary_flag("dbutil01vgs.vgs.untd.com")
server_with_primary_flag("dbutil01dca.dca.untd.com")

set :branch, "production"
