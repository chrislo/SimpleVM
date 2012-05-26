require 'register'

require 'minitest/spec'
require 'minitest/autorun'

describe Register do
  before do
    @register = Register.new
  end

  describe "a new register" do
    it "should have 16 slots" do
      @register.registers.length.must_equal 16
    end

    it "should have nil in each of the slots" do
      @register.registers.each do |register|
        register.must_be_nil
      end
    end
  end

  describe "store" do
    it "should store a number in the named register" do
      @register.store 1, 0
      @register.registers[0].must_equal 1
    end

    it "should prevent storing in an unavailable register" do
      lambda{ @register.store 1, 17 }.must_raise ArgumentError
    end
  end

  describe "load" do
    it "should return the contents of the named register" do
      @register.store 5, 1
      value = @register.load 1
      value.must_equal 5
    end

    it "should raise if an unavailable register is loaded" do
      lambda{ @register.load 17 }.must_raise ArgumentError
    end
  end
end
