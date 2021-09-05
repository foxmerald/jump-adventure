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

    # idle.size = number of images/tiles
    sprites = Gosu::Image.load_tiles(
      @window, 'assets/link.png', @width, @height, true
    )

    @idle = sprites[70..79]

    # center image
    @x = X
    @y = @window.bottom

    @ceiling = @window.bottom - JUMP_HEIGHT

    @jumping = false
    @falling = false
  end

  def update
    if @jumping
      @y -= JUMP_STEP if @y > @ceiling

      if @y == @ceiling
        @jumping = false
        @falling = true
      end

      return
    end

    if @falling
      @y += FALL_STEP if @y < @window.bottom

      if @y == @window.bottom
        @falling = false
      end

      return
    end

    if !@jumping && !@falling && @window.button_down?(Gosu::KbSpace)
      @jumping = true
      @y -= JUMP_STEP
    end
  end

  def draw
    f = (@window.frame / SLOWDOWN) % @idle.size
    image = @idle[f]

    image.draw(@x, @y, 1)
  end

  def reset
    @x = X
    @y = @window.bottom
    @falling = false
    @jumping = false
  end
end
