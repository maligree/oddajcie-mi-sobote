class Monster
  attr_accessor :hitpoints
  attr_accessor :manapoints
  attr_reader :starting_hitpoints
  attr_accessor :x_pos
  attr_accessor :y_pos
  attr_reader :corpse_decay

  def initialize(context, x_pos, y_pos, hitpoints)
    @context = context
    @starting_hitpoints = hitpoints
    @hitpoints = hitpoints
    @x_pos = x_pos
    @y_pos = y_pos
    @was_alive = true
    @exp_value = 15
    @corpse_decay = 30
  end

  def char
    '%'
  end

  def make_a_move(player_x, player_y)
    # If hitpoints above 80%, keep a distance:
    if hp_percent > 0.0 # change this.
      if (player_x-x_pos).abs + (player_y-y_pos).abs < 8
        if player_x < x_pos
          @x_pos += 1
        else
          @x_pos -= 1
        end

        if player_y < y_pos
          @y_pos += 1
        else
          @y_pos -= 1
        end
      else
        if player_x < x_pos
          @x_pos -= 1
        else
          @x_pos += 1
        end

        if player_y < y_pos
          @y_pos -= 1
        else
          @y_pos += 1
        end
      end
    end

  end

  def hp_percent
    (hitpoints.to_f / starting_hitpoints.to_f).round(2)
  end

  def try_to_spawn_a_minion
    if rand(300) == 0
      rand(6).times do
        @context.monsters  << Minion.new(@context, rand(80), rand(30), rand(200))
      end
    end
  end

  def tick
    unless dead?
      if rand(3) == 0
        make_a_move @context.player.x_pos, @context.player.y_pos
      end
    else
      if @was_alive
        @was_alive = false
        @context.killcount.inc
        @context.player.give_experience @exp_value
      else
        @corpse_decay -= 1
      end
    end
    #try_to_spawn_a_minion
  end

  def dead?
    @hitpoints < 0 ? true : false
  end

  def hurt(n)
    @hitpoints -= n
  end

  def color
    if dead?
      Curses::COLOR_RED
    else
      Curses::COLOR_WHITE
    end
  end

  alias x x_pos
  alias y y_pos
end