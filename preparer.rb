require 'pg'
require_relative 'parser'

#Todo security and abort many fileloads

class Preparer

  attr_accessor :finished

  def connection
    parser = Parser.instance
    @con = PG.connect :dbname => parser.db_name, :user => parser.db_user,
                      :password => parser.db_password
    @finished = 0
  end

  def db_execute(table_name, str, records, &block)
    if @con
      @con.exec "DROP TABLE IF EXISTS #{table_name}"
      @con.exec "CREATE TABLE #{table_name}(Id SERIAL NOT NULL,
        Fill VARCHAR(2000))"
      for i in 1..records do
        @con.exec "INSERT INTO #{table_name} (Fill) VALUES('#{str}')"
        @finished += 1
        yield
      end

    end
  rescue PG::Error => e
    puts e.message
  end

  def db_close
    @con.close if @con
  end


end