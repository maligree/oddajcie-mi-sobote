#!/usr/bin/env ruby

require 'bundler/setup'
require 'gaminator'

require_relative 'player'
require_relative 'message'
require_relative 'monster'
require_relative 'explosions'
require_relative 'beams'
require_relative 'bloodhit'
require_relative 'minion'
require_relative 'battlelist'
require_relative 'killcount'


class Encounter
  attr_reader :player
  attr_accessor :monsters
  attr_accessor :message
  attr_accessor :bloodhits
  attr_reader :killcount

  def initialize(width, height)
    @width = width
    @height = height
    @player = Player.new(self, 5, 5)
    @wait = false
    @monsters = [
        Monster.new(self, 20, 20, 400),
        Monster.new(self, 24, 29, 400),
        Monster.new(self, 50, 30, 400),
        Minion.new(self, 23, 16, 80),
    ]
    @events = []
    @message = Message.new 'GO, GO, MURDER.', 15
    @marker = OrientationMarker.new
    @bloodhits = []
    @killcount = Killcount.new self

  end

  def tick
    @message.tick

    @events.each do |e|
      e.tick
    end
    @events.delete_if do |e|
      e.done?
    end

    @monsters.each do |m|
      m.tick
    end

    @monsters.delete_if do |m|
      m.corpse_decay == 0
    end

    @marker.update(@player.x_pos, @player.y_pos, @player.orientation)

    @bloodhits.each do |b|
      b.tick
    end

    @bloodhits.delete_if do |b|
      !b.relevant?
    end

    @battlelist = []
    @monsters.each_with_index do |m, i|
      @battlelist << BattlelistEntry.new(m.char, m, i)
    end

    if rand(1000) == 0
      @monsters << Monster.new(self, rand(50), rand(50), rand(700))
    end

    @player.tick

  end

  def exit_message
    'YEAH GET LOST'
  end

  def sleep_time
    0.1
  end

  def objects
    ([].concat(@events).concat(@monsters) << @player << @marker) .concat(@bloodhits) .concat(@battlelist) << @killcount
  end

  def textbox_content
    if @message.relevant?
      @message.text
    else
      "HP: #{@player.hitpoints} " \
      "MP: #{@player.mana} " \
    end
  end

  def wait?
    @wait
  end

  def input_map
    {
      ?w => :move_up,
      ?s => :move_down,
      ?a => :move_left,
      ?d => :move_right,
      ?/ => :fuck_this,
      ?q => :rotate_left,
      ?e => :rotate_right,
      ?8 => :cast_explosion,
      ?9 => :debug_cause_reasonable_explosion,
      ?7 => :cast_beam,
      ?r => :hacky_restart,
    }
  end

  def move_up
    @player.y_pos -= 1
  end

  def move_down
    @player.y_pos += 1
  end

  def move_left
    @player.x_pos -= 1
  end

  def move_right
    @player.x_pos += 1
  end

  def rotate_left
    @player.rotate_left
  end

  def rotate_right
    @player.rotate_right
  end

  def fuck_this
    exit
  end

  def debug_cause_reasonable_explosion
    @events << ReasonableExplosion.new(self, rand(80), rand(30))
  end

  def cast_beam
    if @player.mana >= 35
      @events << SmallBeam.new(self, @player.x_pos, @player.y_pos, @player.orientation)
      @player.mana -= 35
    else
      @message = Message.new("You don't have enough mana!", 10)
    end
  end

  def cast_explosion
    if @player.mana >= 25
      case @player.orientation
        when 0
          y = @player.y_pos - 6 + rand(3)
          x = @player.x_pos - 2 + rand(3)
        when 1
          x = @player.x_pos + 2 + rand(3)
          y = @player.y_pos - 2 + rand(3)
        when 2
          x = @player.x_pos - 2 + rand(3)
          y = @player.y_pos + 2 + rand(3)
        when 3
          x = @player.x_pos - 6 + rand(3)
          y = @player.y_pos - 2 + rand(3)
      end
      @events << TinyExplosion.new(self, x, y)
      @player.mana -= 25
    else
      @message = Message.new("You don't have enough mana!", 10)
    end
  end

  def hacky_restart
    @player = Player.new(self, 5, 5)
    @wait = false
    @monsters = [
        Monster.new(self, 20, 20, 400),
        Minion.new(self, 23, 16, 80),
    ]
    @events = []
    @message = Message.new 'GO, GO, MURDER.', 5
    @marker = OrientationMarker.new
    @bloodhits = []
  end
end


Gaminator::Runner.new(Encounter).run