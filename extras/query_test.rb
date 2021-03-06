require "dbi"
require "oci8"


class QueryTest

  attr_reader :column_names, :result_set, :error

  def initialize(database_url,username,password,sql_text,sql_type,timeout)
    @database_url = database_url
    @username = username
    @password = password
    @sql_text = sql_text
    @column_names = Array.new
    @timeout = timeout
    @error = nil
    
    # SQL = 1 , PLSQL = 2
    @sql_type = sql_type
  end

  def test
    start_time = Time.now.to_i

    # Kick off separate thread to run query
    thread = Thread.new{test_query}
    while Time.now.to_i - start_time < @timeout do
      # Sleep 1 second
      sleep(1)
      # Break if thread finished
      break if !thread.alive?
    end

    # If we timed out, kill thread and set error
    if (Time.now.to_i - start_time >= @timeout) and(thread.alive?) then
      thread.kill
      @error = "Connection to the target or execution of the query timed out"
    end

  end

  def test_query
    
    begin

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

        @database_url = @database_url.gsub("dbi:OCI8:","")
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

    rescue Exception => e
      @error = "Error:#{e.message}"
    end

  end
   

end