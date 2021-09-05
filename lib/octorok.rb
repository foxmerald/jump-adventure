# frozen_string_literal: true

require 'gosu'

class Octorok
  attr_accessor :x, :y, :width, :height, :reset

  SLOWDOWN = 20

  def initialize(window)
    @window = window

    @width = 100
    @height = 79

    # idle.size = number of images/tiles
    sprites = Gosu::Image.load_tiles(
      @window, 'assets/octorok_red.png', @width, @height, true
    )

    @idle = sprites

    @x = @window.width
    @y = @window.bottom + 20
  end

  def update
    @x = @window.width + 50 if @x < -100
    @x -= @window.speed
  end

  def draw
    f = (@window.frame / SLOWDOWN) % 4 # @idle.size

    image = @idle[f]

    image.draw(@x, @y, 1)
  end

  def reset
    @x = @window.width
    @y = @window.bottom + 20
  end
end
