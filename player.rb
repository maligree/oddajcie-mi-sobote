class Player
  attr_accessor :hitpoints
  attr_accessor :x_pos
  attr_accessor :y_pos
  attr_reader :orientation
  attr_reader :char
  attr_reader :experience
  attr_reader :level
  attr_accessor :mana

  def initialize(context, x_pos, y_pos)
    @context = context
    @x_pos = x_pos
    @y_pos = y_pos
    @hitpoints = 500
    @orientation = 0
    @char = 'O'
    @level = 1
    @experience = 0
    @mana = 700
  end

  def tick
    @mana += 1
  end

  alias x x_pos
  alias y y_pos

  def rotate_left
    @orientation = (@orientation - 1) % 4
  end

  def rotate_right
    @orientation = (@orientation + 1) % 4
  end

  def give_experience(n)
    @experience += n
    if @experience >= exp_value(@level + 1)
      @context.message = Message.new("You advanced to level #{@level+1}!", 10)
      @level += 1
    end
  end

  def exp_value(n)
    if n == 2
      100
    else
      (100 * (1.1**(@level-1))).floor + exp_value(n - 1)
    end
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