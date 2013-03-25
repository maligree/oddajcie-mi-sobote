

class SmallBeam
  attr_reader :x, :y
  attr_reader :texture

  def initialize(context, x, y, orientation)
    @context = context
    @x = x
    @y = y
    @ttl = 7
    @orientation = orientation
    if orientation % 2 == 1
      @phases = [
          [
            '          ',
          ],
          %w(~~~~~~~~~~),
          %w(%%%%%%%%%%),
          %w(XKXKXKXKXK),
          %w(xxxxxxxxxx),
          %w(~~~~~~~~~~),
          %w(----------),
      ]
      if orientation == 3
        @x -= 9
      end
    else
      @phases = [
          [
              ' ',
              ' ',
              ' ',
              ' ',
              ' ',
              ' ',
              ' ',
              ' ',
              ' ',
              ' ',
          ],
          %w(~ ~ ~ ~ ~ ~ ~ ~ ~ ~),
          %w(% % % % % % % % % %),
          %w(X K X K X K X K X K),
          %w(x x x x x x x x x x),
          %w(~ ~ ~ ~ ~ ~ ~ ~ ~ ~),
          %w(| | | | | | | | | |),
      ]
      if orientation == 0
        @y -= 9
      end
    end

    @texture = @phases[@ttl - 1]
  end

  def tick
    unless done?
      @ttl -= 1
      @texture = @phases[@ttl]
    end

    # see if he hit something
    if @ttl == 4
      damage = 10 + @context.player.level*2 + rand(30 * (1.2**@context.player.level))
      @context.monsters.each do |m|
        if @orientation == 0 or @orientation == 2
          if m.y_pos.between?(@y, @y+9) and m.x_pos == @x
            unless m.dead?
              @context.message = Message.new "You hit for #{damage} points.", 7
              @context.bloodhits << Bloodhit.new(m.x_pos + 3, m.y_pos + 2, damage)
              m.hurt(damage)
            end
          end
        elsif @orientation == 1 or @orientation == 3
          if m.x_pos.between?(@x, @x+9) and m.y_pos == @y
            unless m.dead?
              @context.message = Message.new "You hit for #{damage} points.", 7
              @context.bloodhits << Bloodhit.new(m.x_pos+2, m.y_pos+2, damage)
              m.hurt(damage)
            end
          end

        end
      end
    end
  end

  def done?
    @ttl > 0 ? false : true
  end
end