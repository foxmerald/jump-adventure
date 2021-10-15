# frozen_string_literal: true

require 'gosu'

Dir["#{File.dirname(__FILE__)}/lib/*.rb"].sort.each { |file| require file }

class JumpAdventure < Gosu::Window
  BASE_SPEED = 4
  SHORT_PRESS_FRAME = 15
  COLLISION_BUFFER = 15

  attr_accessor :speed, :frame, :bottom, :game_over, :short_press

  def initialize(width = 1200, height = 600, fullscreen = false)
    super

    self.caption = "Link's Jump Adventure"

    @frame = 0

    @explosion = Gosu::Image.new('assets/collision.png')
    @game_over_text = Gosu::Image.new('assets/game_over.png')
    @restart_options = Gosu::Image.from_text(
      self, 'Press [Space] to try again. Press [Esc] to exit.', Gosu.default_font_name, 30
    )

    @speed = 4
    @bottom = 440
    @game_over = false

    @link = Link.new(self)
    @octorok = Octorok.new(self)
    @keese = Keese.new(self)
    @background = Background.new(self)

    @short_press = false
    @space_down_frame = 0
  end

  def button_down(id)
    close if id == Gosu::KbEscape

    @space_down_frame = @frame if id == Gosu::KbSpace
    @short_press = false
  end

  def button_up(id)
    if id == Gosu::KbSpace && @frame - @space_down_frame <= SHORT_PRESS_FRAME
      @short_press = true
    end

    restart_game if id == Gosu::KbSpace
  end

  def update
    return if @game_over

    @frame += 1

    @link.update
    @octorok.update
    @keese.update
    @background.update

    @score = Gosu::Image.from_text(
      self, "Score: #{(@background.x / 50).abs}", Gosu.default_font_name, 30
    )

    increase_speed

    @game_over = true if collision?
  end

  def draw
    @link.draw
    @octorok.draw
    @keese.draw
    @background.draw

    @score.draw(0, 0, 100)

    show_game_over if @game_over
  end

  private

  def collision?
    link_front = @link.x + @link.width
    link_foot = @link.y + @link.height
    link_head = @link.y
    link_back = @link.x

    octorok_front = @octorok.x + COLLISION_BUFFER
    octorok_head = @octorok.y + COLLISION_BUFFER
    octorok_back = @octorok.x + @octorok.width - COLLISION_BUFFER

    keese_front = @keese.x + COLLISION_BUFFER
    keese_head = @keese.y + COLLISION_BUFFER
    keese_foot = @keese.y + @keese.height - COLLISION_BUFFER - 20

    octorok_collision = link_front >= octorok_front && link_foot >= octorok_head

    keese_colission = link_front >= keese_front && link_foot >= keese_head && link_head <= keese_foot

    octorok_collision = link_back <= octorok_back && link_front >= octorok_front && link_foot >= octorok_head
    keese_collision = link_front >= keese_front && link_foot >= keese_head && link_head <= keese_foot

    octorok_collision || keese_collision
  end

  def show_game_over
    @explosion.draw(@octorok.x - @octorok.width / 2, @octorok.y - @octorok.height / 2, 100)

    @game_over_text.draw(width / 2 - @game_over_text.width / 2, height / 2 - @game_over_text.height / 2, 100)

    @restart_options.draw(width / 2 - @restart_options.width / 2, height - 35, 100)
  end

  def restart_game
    @frame = 0
    @speed = 4

    @link.reset
    @octorok.reset
    @keese.reset

    @game_over = false
  end

  def increase_speed
    increased_speed = @frame/750 + BASE_SPEED

    @speed = increased_speed
  end
end
