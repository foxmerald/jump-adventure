# frozen_string_literal: true

require 'gosu'
require_relative '../helpers/coords'

class Link
  attr_accessor :x, :y, :width, :height

  include Coords

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

    @game_over_sprite = Gosu::Image.load_tiles(
      @window, 'assets/link.png', @width, @height, true
    )[2]

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

    return @game_over_sprite.draw(@x, @y, 1) if @window.game_over

    image = if @jumping
      @sprites[7]
    elsif @falling
      @sprites[5]
    else
    f = (@window.frame / SLOWDOWN) % @sprites.size
      @sprites[f]
    end

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
    top = @window.short_press ? @ceiling + 150 : @ceiling
    @y -= JUMP_STEP if @y > top

    return unless @y == top

    @jumping = false
    @falling = true
  end
end
