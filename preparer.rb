require 'pg'
require_relative 'parser'

class Preparer

  attr_accessor :finished

  def connection
    @con = PG.connect :dbname => Parser.config['db_name'], :user => Parser.config['db_user'],
                      :password => Parser.config['db_password']
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