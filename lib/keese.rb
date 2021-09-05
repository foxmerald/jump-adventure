# frozen_string_literal: true

require 'gosu'
require_relative '../helpers/coords'

class Keese
  attr_accessor :x, :y, :width, :height

  include Coords

  SLOWDOWN = 20

  def initialize(window)
    @window = window

    @width = 76
    @height = 72

    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/keese.png', @width, @height, true
    )

    @x = @window.width
    @y = @window.bottom - 150
  end

  def update
    @x = @window.width + 50 if @x < -100

    @x -= @window.speed
  end

  def draw
    f = (@window.frame / SLOWDOWN) % 4 # @sprites.size

    image = @sprites[f]

    image.draw(@x, @y, 1)
  end

  def reset
    @x = @window.width
    @y = @window.bottom - 150
  end
end
