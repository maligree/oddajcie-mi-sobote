class Bloodhit
  attr_accessor :x, :y
  attr_accessor :texture
  attr_accessor :color
  def initialize(x, y, value)
    @ttl = 5
    @x = x
    @y = y
    @value = value
    @texture = [ value.to_s ]
    @color = Curses::COLOR_MAGENTA
  end

  def tick
    @ttl -= 1
  end

  def relevant?
    @ttl > 0 ? true : false
  end
end