class Killcount
  attr_accessor :x, :y

  def initialize
    @x = 120
    @y = 3
    @count = 0
  end

  def texture
    [
      "Kill count: #{@count.to_s}"
    ]
  end

  def inc
    @count += 1
  end
end