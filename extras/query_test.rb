require "dbi"
require "oci8"


class QueryTest

  attr_reader :column_names, :result_set

  def initialize(database_url,username,password,sql_text,sql_type)
    @database_url = database_url
    @username = username
    @password = password
    @sql_text = sql_text
    @column_names = Array.new
    
    # SQL = 1 , PLSQL = 2
    @sql_type = sql_type
  end
  
  def test
    
  
    if @sql_type == "1" then
  
      DBI.connect(@database_url, @username, @password) do | dbh |   
    
      
        sth = dbh.prepare(@sql_text)
        sth.execute
      
        rownum = 0
        @result_set = Array.new
      
        sth.fetch_array do |row| 
          # Save column information     
          @column_names = sth.column_names
          @result_set << row
          rownum +=1
          break if rownum > 10
        end      
      end  
        
    else 
        # Strip off Ruby portion of the URL
        # Thats because OCI8 call is low-level OCI call, not Ruby call

        @database_url = @database_url.gsub("dbi:oci8:","")
        conn = OCI8.new(@username, @password, @database_url)
        # parse PL/SQL
        plsql = conn.parse(@sql_text)
        # bind :cursor as OCI8::Cursor
        plsql.bind_param(':cursor', OCI8::Cursor)
        # execute
        plsql.exec
        # get a bind value, which is an OCI8::Cursor.
        cursor = plsql[':cursor']
        
        # fetch results from the cursor.
        rownum = 0
        @result_set = Array.new
        while row = cursor.fetch()
          @column_names = cursor.getColNames
          @result_set << row
          rownum +=1
          break if rownum > 10
        end  
        
        cursor.close()
        plsql.close()
        conn.logoff()
    end 

  end
   

end