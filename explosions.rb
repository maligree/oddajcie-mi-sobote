class TinyExplosion
  attr_reader :x, :y
  attr_reader :texture

  def initialize(context, x, y)
    @context = context
    @x = x
    @y = y
    @ttl = 6
    @phases = [
        [
            '   ',
            '   ',
            '   ',
        ],
        [
            ' , ',
            ',,,',
            ' , ',
        ],
        [
            ' * ',
            '***',
            ' * ',
        ],
        [
            ' % ',
            '%%%',
            ' % ',
        ],

        [
            ' @ ',
            '@@@',
            ' @ ',
        ],

        [
            ' . ',
            '...',
            ' . ',
        ]
    ]

    @texture = @phases[@ttl - 1]
  end

  def tick
    unless done?
      if @ttl == 5
        damage = 2 + @context.player.level*2 + rand(30 * (1.2**@context.player.level))
        @context.monsters.each do |m|
          if m.x_pos.between?(@x, @x+2) and m.y_pos == @y+1
            unless m.dead?
              @context.message = Message.new "You hit for #{damage} points.", 7
              @context.bloodhits << Bloodhit.new(m.x_pos + 3, m.y_pos + 2, damage)
              m.hurt(damage)
            end
          elsif m.y_pos.between?(@y, @y+2) and m.x_pos == @x+1
            unless m.dead?
              @context.message = Message.new "You hit for #{damage} points.", 7
              @context.bloodhits << Bloodhit.new(m.x_pos + 3, m.y_pos + 2, damage)
              m.hurt(damage)
            end
          end
        end
      end
      @ttl -= 1
      @texture = @phases[@ttl]
    end

  end

  def done?
    @ttl > 0 ? false : true
  end
end

class ReasonableExplosion

  attr_reader :x, :y
  attr_reader :texture

  def initialize(context, x, y)
    @context = context
    @x = x
    @y = y
    @ttl = 6
    @phases = [
        [
            '      ',
            '      ',
            '      ',
            '      ',
            '      ',
        ],
        [
            '  ,,  ',
            ' ,,,, ',
            ',,,,,,',
            ' ,,,, ',
            '  ,,  ',
        ],
        [
            '  **  ',
            ' **** ',
            '******',
            ' **** ',
            '  **  ',
        ],
        [
            '  %%  ',
            ' %%%% ',
            '%%%%%%',
            ' %%%% ',
            '  %%  ',
        ],

        [
            '  @@  ',
            ' @@@@ ',
            '@@@@@@',
            ' @@@@ ',
            '  @@  '
        ],

        [
            '  ..  ',
            ' .... ',
            '......',
            ' .... ',
            '  ..  ',
        ]
    ]

    @texture = @phases[@ttl - 1]
  end

  def tick
    unless done?
      @ttl -= 1
      @texture = @phases[@ttl]
    end

    if @ttl == 4 or @ttl == 3
      @context.monsters.each do |m|
        if m.x == @x and m.y == @y
          @context.message = Message.new "YOU HIT SOMETHING DUDE, YO", 20
        end
      end
    end
  end

  def done?
    @ttl > 0 ? false : true
  end
end
