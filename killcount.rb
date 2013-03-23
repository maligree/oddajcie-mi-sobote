class Killcount
  attr_accessor :x, :y

  def initialize
    @x = 110
    @y = 10
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