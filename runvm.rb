$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'interpreter'

code = File.read(ARGV[0])
i = Interpreter.new code
i.run
