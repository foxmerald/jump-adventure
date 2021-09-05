# frozen_string_literal: true

require 'gosu'

class Keese
  attr_accessor :x, :y, :width, :height, :reset

  SLOWDOWN = 20

  def initialize(window)
    @window = window

    @width = 76
    @height = 72

    # idle.size = number of images/tiles
    sprites = Gosu::Image.load_tiles(
      @window, 'assets/keese.png', @width, @height, true
    )

    @idle = sprites

    @x = @window.width
    @y = @window.bottom - 150

    # direction and movement
    @frame = 0
  end

  def update
    @x = @window.width + 50 if @x < -100

    @x -= @window.speed
  end

  def draw
    f = (@window.frame / SLOWDOWN) % 4 # @idle.size

    image = @idle[f]

    image.draw(@x, @y, 1)

    # Gosu.draw_rect(@x, @y, @width, @height, Gosu::Color.argb(0xff_00ff00), 99)
  end

  def reset
    @x = @window.width
    @y = @window.bottom - 150
  end
end
