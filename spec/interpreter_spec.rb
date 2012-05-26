require 'interpreter'

require 'minitest/spec'
require 'minitest/autorun'
require 'mocha'

describe Interpreter do
  before do
    code = "PUSH 2\nPUSH 4\nADD\n"
    @it = Interpreter.new code
  end

  describe "initialize" do
    it "should create an array of instructions from the provided source" do
      @it.instructions.must_equal ["PUSH 2", "PUSH 4", "ADD"]
    end
  end

  describe "next_instruction" do
    it "should return the next instruction until there are no more" do
      @it.next_instruction.must_equal "PUSH 2"
      @it.next_instruction.must_equal "PUSH 4"
      @it.next_instruction.must_equal "ADD"
      @it.next_instruction.must_equal nil
    end
  end

  describe "run" do
    before do
      @mock_vm = mock()
      @mock_register = mock()
    end

    def run_interpreter_with_instruction(instruction)
      i = Interpreter.new instruction, @mock_vm, @mock_register
      i.run
    end

    it "should interpret PUSH" do
      @mock_vm.expects(:push).with(2)
      run_interpreter_with_instruction "PUSH 2"
    end

    it "should interpret POP" do
      @mock_vm.expects(:pop)
      run_interpreter_with_instruction "POP"
    end

    it "should interpret ADD" do
      @mock_vm.expects(:add)
      run_interpreter_with_instruction "ADD"
    end

    it "should interpret DUP" do
      @mock_vm.expects(:dup)
      run_interpreter_with_instruction "DUP"
    end

    it "should interpret PRINT" do
      @mock_vm.expects(:print)
      run_interpreter_with_instruction "PRINT"
    end

    it "should interpret JUMP" do
      @mock_vm.expects(:push).with(4)
      run_interpreter_with_instruction "JUMP 2\nPUSH 2\nPUSH 4\n"
    end

    it "should interpret LOAD" do
      @mock_register.expects(:load).with(0).returns(:contents_of_register)
      @mock_vm.expects(:push).with(:contents_of_register)
      run_interpreter_with_instruction "LOAD 0"
    end

    it "should interpret STORE" do
      @mock_vm.expects(:pop).returns(:top_of_stack)
      @mock_register.expects(:store).with(:top_of_stack, 0)
      run_interpreter_with_instruction "STORE 0"
    end

    it "should interpret IFEQ with 0" do
      vm = VM.new
      Interpreter.new("PUSH 0\nIFEQ 3\nPUSH 2\nPUSH 4\n", vm).run
      vm.stack.must_equal [0, 2, 4]
    end

    it "should interpret IFEQ with jump" do
      vm = VM.new
      Interpreter.new("PUSH 1\nIFEQ 3\nPUSH 2\nPUSH 4\n", vm).run
      vm.stack.must_equal [1, 4]
    end

    it "should run while no more instructions are availabe" do
      @mock_vm.expects(:push).twice
      run_interpreter_with_instruction "PUSH 2\nPUSH 4"
    end
  end
end
