require 'pg'
USER = 'valentine'
PASSWORD = '123'

class SpeedTest

  attr_accessor :finished

  def connection
    @con = PG.connect :dbname => 'testdb', :user => USER,
                      :password => PASSWORD
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

class ThreadCLock

  def initialize(str, threads, records)
    @threads = threads
    @records = records
    @str = str
  end

  def prepare_instances


    @threads.times.map do
      SpeedTest.new
    end
  end

  def define_threads
    array = prepare_instances
    threads = []
    start_time = Time.now
    array.each_with_index do |arr, index|
      threads << Thread.new do


        arr.connection
        arr.db_execute("t" + index.to_s, @str, @records / @threads) do
          str = "\r"
          array.each_with_index do |obj, index|
            str += "|| ##{index} | #{obj.finished} ||"
          end
          total_seconds = Time.now - start_time
          seconds = ((total_seconds % 3600) % 60).to_i
          str += "  #{seconds}"
          print str
        end
        arr.db_close
        puts index
      end
    end


    threads
  end

  def run
    t1 = Time.now
    define_threads.each {|thr| thr.join}
    t2 = Time.now
    puts 'Time with milliseconds: ' + ((t2 - t1)).to_s
  end

  def test_method
    # method for testing
  end


end

test = ThreadCLock.new('444', ARGV[1].to_i, ARGV[0].to_i)

test.run

