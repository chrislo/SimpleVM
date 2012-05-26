class Register
  attr_reader :registers

  def initialize
    @registers = Array.new(16)
  end

  def store(contents, register)
    raise ArgumentError if register > 15
    @registers[register] = contents
  end

  def load(register)
    raise ArgumentError if register > 15
    @registers[register]
  end
end
