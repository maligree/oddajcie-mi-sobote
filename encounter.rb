#!/usr/bin/env ruby

require "bundler/setup"
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
    @player = Player.new(5, 5)
    @wait = false
    @monsters = [
        Monster.new(self, 20, 20, 400),
        Minion.new(self, 23, 16, 80),
    ]
    @events = []
    @message = Message.new 'GO, GO, MURDER.', 15
    @marker = OrientationMarker.new
    @bloodhits = []
    @killcount = Killcount.new

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

    if rand(30) == 0
      @monsters << Monster.new(self, rand(50), rand(50), rand(700))
    end

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
      "Player at (#{@player.x_pos}, #{@player.y_pos}). " \
      "Hitpoints: #{@player.hitpoints}; " \
      "Orientation: #{@player.orientation}."
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
      ?0 => :debug_cause_tiny_explosion,
      ?9 => :debug_cause_reasonable_explosion,
      ?7 => :debug_beam,
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

  def debug_cause_tiny_explosion
    @events << TinyExplosion.new(self, rand(80), rand(30))
  end

  def debug_cause_reasonable_explosion
    @events << ReasonableExplosion.new(self, rand(80), rand(30))
  end

  def debug_beam
    @events << SmallBeam.new(self, @player.x_pos, @player.y_pos, @player.orientation)
  end

  def hacky_restart
    @player = Player.new(5, 5)
    @wait = false
    @monsters = [
        Monster.new(self, 20, 20, 400),
        Minion.new(self, 23, 16, 80),
    ]
    @events = []
    @message = Message.new 'GO, GO, MURDER.', 15
    @marker = OrientationMarker.new
    @bloodhits = []
  end
end


Gaminator::Runner.new(Encounter).run