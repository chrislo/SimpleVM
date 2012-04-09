require 'vm'

class Interpreter
  def initialize(source_code, vm = VM.new)
    @instructions = source_code.split(/\n/)
    @ptr = 0
    @vm = vm
  end

  def instructions
    @instructions
  end

  def next_instruction
    i = @instructions[@ptr]
    @ptr += 1
    i
  end

  def run
    while i = next_instruction do
      case i
      when /PUSH (\d+)/
        @vm.push $1.to_i
      when /POP/
        @vm.pop
      when /ADD/
        @vm.add
      when /DUP/
        @vm.dup
      when /PRINT/
        print @vm.print
      when /JUMP (\d+)/
        @ptr = $1.to_i
      when /IFEQ (\d+)/
        next if @vm.top == 0
        @ptr = $1.to_i
      end
    end
  end
end
