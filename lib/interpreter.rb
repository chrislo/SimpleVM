require 'vm'

class Interpreter
  def initialize(source_code, vm = VM.new, register = Register.new)
    @instructions = source_code.split(/\n/)
    @ptr = 0
    @vm = vm
    @register = register
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
      when /LOAD (\d+)/
        # push the contents of the register on to the stack
        @vm.push @register.load $1.to_i
      when /STORE (\d+)/
        # store the top of the stack in the register
        @register.store @vm.pop, $1.to_i
      end
    end
  end
end
