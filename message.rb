class Message
  attr_reader :text
  def initialize(text, duration)
    @text = text
    @duration = duration
  end

  def tick
    if relevant?
      @duration -= 1
    end
  end

  def relevant?
    @duration > 0 ? true : false
  end
end