require_relative 'thread_clock'

test = ThreadCLock.new('444', ARGV[1], ARGV[0])

test.run