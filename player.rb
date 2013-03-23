class Player
  attr_accessor :hitpoints
  attr_accessor :x_pos
  attr_accessor :y_pos
  attr_reader :orientation
  attr_reader :char

  def initialize(x_pos, y_pos)
    @x_pos = x_pos
    @y_pos = y_pos
    @hitpoints = 500
    @orientation = 0
    @char = 'O'
  end

  def tick

  end

  alias x x_pos
  alias y y_pos

  def rotate_left
    @orientation = (@orientation - 1) % 4
  end

  def rotate_right
    @orientation = (@orientation + 1) % 4
  end
end

class OrientationMarker
  attr_accessor :x, :y
  attr_accessor :char
  attr_accessor :color

  def initialize
    @color = Curses::COLOR_YELLOW
  end

  def update(x, y, orientation)
    @x = x
    @y = y
    case orientation
      when 0
        @char = '^'
        @y -= 1
      when 1
        @char = '>'
        @x += 1
      when 2
        @char = 'V'
        @y += 1
      when 3
        @char = '<'
        @x -= 1
      else
        # type code here
    end
  end
end