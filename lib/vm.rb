class VM
  attr_reader :stack

  def initialize
    @stack = []
  end

  def push num
    stack.push num
  end

  def pop
    stack.pop
  end

  def add
    push pop + pop
  end

  def top
    stack.last
  end

  def print
    top.to_s
  end

  def dup
    push top
  end
end
