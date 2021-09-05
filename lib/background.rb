# frozen_string_literal: true

require 'gosu'

class Background
  attr_accessor :x, :y, :width, :height

  SLOWDOWN = 20

  def initialize(window)
    @window = window

    @background = Gosu::Image.new('assets/background.png')

    @x = 0
    @y = 0
  end

  def update
    @x -= @window.speed / 4
  end

  def draw
    next_x = @x % - @background.width

    @background.draw(next_x, @y, 0)
    @background.draw(next_x + @background.width, @y, 0) if next_x < (@background.width - @window.width)
  end
end
