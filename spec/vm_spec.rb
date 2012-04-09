require 'vm'

require 'minitest/spec'
require 'minitest/autorun'

describe VM do
  before do
    @vm = VM.new
  end

  describe "push" do
    it "should push numbers to the stack" do
      @vm.push 2
      @vm.push 4
      @vm.stack.must_equal [2,4]
    end
  end

  describe "pop" do
    before do
      @vm.push 2
      @vm.push 4
    end

    it "should return the popped number" do
      @vm.pop.must_equal 4
      @vm.stack.must_equal [2]
    end
  end

  describe "add" do
    before do
      @vm.push 2
      @vm.push 4
    end

    it "should add the top two numbers and push back on to the stack" do
      @vm.add
      @vm.stack.must_equal [6]
    end
  end

  describe "print" do
    it "should return the top item of the stack as a string" do
      @vm.push 4
      @vm.push 6
      @vm.print.must_equal "6"
    end
  end

  describe "dup" do
    it "should push a copy of what's at the top of the stack back onto the stack" do
      @vm.push 6
      @vm.dup
      @vm.stack.must_equal [6, 6]
    end
  end
end
