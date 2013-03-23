class Battlelist
  attr_accessor :x, :y


  def initialize(context)
    @context = context
  end

  def tick

  end

end

class BattlelistEntry
  attr_accessor :x, :y

  def initialize(char, m, offset)
    @x = 80
    @y = 2 + offset
    @char = char
    @m = m
  end

  def color
    if @m.hp_percent < 0.3
      Curses::COLOR_RED
    elsif @m.hp_percent < 0.6
      Curses::COLOR_YELLOW
    elsif @m.hp_percent <= 1.0
      Curses::COLOR_GREEN
    else
      Curses::COLOR_WHITE
    end
  end

  def texture
    ["#{@char.to_s} health: #{@m.hp_percent.to_s}%, #{@m.hitpoints.to_s}/#{@m.starting_hitpoints} hp"]
  end
end