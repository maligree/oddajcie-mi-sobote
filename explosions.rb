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
