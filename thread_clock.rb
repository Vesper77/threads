require_relative 'preparer'




class ThreadCLock

  def initialize(str, threads, records)
    threads ? @threads = threads.to_i : @threads = 4
    records ? @records = records.to_i : @records = 10000
    @str = str
  end

  def prepare_instances
    @threads.times.map do
      Preparer.new
    end
  end

  def one_execute(arr, array, start_time,index)
    arr.db_execute("t" + index.to_s, @str, @records / @threads) do
      str = "\r"
      array.each_with_index do |obj, ind|
        str += "|| ##{ind} | #{obj.finished} ||"
      end
      total_seconds = Time.now - start_time
      seconds = ((total_seconds % 3600) % 60).to_i
      str += "  #{seconds}"
      print str
    end
  end

  def instances_execute(array, threads, start_time)
    array.each_with_index do |arr, index|
      threads << Thread.new do
        arr.connection
        one_execute(arr, array, start_time,index)
        arr.db_close
        puts index
      end
    end
  end

  def define_threads
    array = prepare_instances
    start_time = Time.now
    instances_execute(array, threads = [], start_time)
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


