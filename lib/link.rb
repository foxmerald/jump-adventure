# frozen_string_literal: true

require 'gosu'

class Link
  attr_accessor :x, :y, :width, :height

  X = 16
  SLOWDOWN = 10
  JUMP_HEIGHT = 360
  JUMP_STEP = 10
  FALL_STEP = 5

  def initialize(window)
    @window = window

    @width = 96
    @height = 104

    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/link.png', @width, @height, true
    )[70..79]

    @x = X
    @y = @window.bottom

    @ceiling = @window.bottom - JUMP_HEIGHT

    @jumping = false
    @falling = false
  end

  def update
    return handle_jump if @jumping
    return handle_fall if @falling

    jump if @window.button_down?(Gosu::KbSpace)
  end

  def draw
    f = (@window.frame / SLOWDOWN) % @sprites.size
    image = @sprites[f]

    image.draw(@x, @y, 1)
  end

  def reset
    @x = X
    @y = @window.bottom
    @falling = false
    @jumping = false
  end

  private

  def jump
    @jumping = true
    @y -= JUMP_STEP
  end

  def handle_fall
    @y += FALL_STEP if @y < @window.bottom
    @falling = false if @y == @window.bottom
  end

  def handle_jump
    @y -= JUMP_STEP if @y > @ceiling

    return unless @y == @ceiling

    @jumping = false
    @falling = true
  end
end
