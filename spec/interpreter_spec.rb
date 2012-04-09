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
    end

    it "should parse PUSH" do
      @mock_vm.expects(:push).with(2)
      i = Interpreter.new "PUSH 2", @mock_vm
      i.run
    end

    it "should parse POP" do
      @mock_vm.expects(:pop)
      Interpreter.new("POP\n", @mock_vm).run
    end

    it "should parse ADD" do
      @mock_vm.expects(:add)
      Interpreter.new("ADD\n", @mock_vm).run
    end

    it "should parse DUP" do
      @mock_vm.expects(:dup)
      Interpreter.new("DUP\n", @mock_vm).run
    end

    it "should parse PRINT" do
      @mock_vm.expects(:print)
      Interpreter.new("PRINT\n", @mock_vm).run
    end

    it "should parse JUMP" do
      @mock_vm.expects(:push).with(4)
      Interpreter.new("JUMP 2\nPUSH 2\nPUSH 4\n", @mock_vm).run
    end

    it "should parse IFEQ with 0" do
      vm = VM.new
      Interpreter.new("PUSH 0\nIFEQ 3\nPUSH 2\nPUSH 4\n", vm).run
      vm.stack.must_equal [0, 2, 4]
    end

    it "should parse IFEQ with jump" do
      vm = VM.new
      Interpreter.new("PUSH 1\nIFEQ 3\nPUSH 2\nPUSH 4\n", vm).run
      vm.stack.must_equal [1, 4]
    end

    it "should parse IFEQ with 0" do
      vm = VM.new
      vm.expects(:push).with(0)
      vm.expects(:push).with(4)
      Interpreter.new("PUSH 0\nIFEQ 3\nPUSH 2\nPUSH 4\n", vm).run
    end

    it "should run while no more instructions are availabe" do
      @mock_vm.expects(:push).twice
      Interpreter.new("PUSH 2\nPUSH 4", @mock_vm).run
    end
  end
end
