class Killcount
  attr_accessor :x, :y

  def initialize(context)
    @context = context
    @x = 120
    @y = 3
    @count = 0
  end

  def texture
    [
      "Kill count: #{@count.to_s}",
      "Level: #{@context.player.level.to_s}",
      "Experience: #{@context.player.experience.to_s}",
    ]
  end

  def inc
    @count += 1
  end

end