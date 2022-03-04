# frozen_string_literal: true

require_relative './lib/game'
require_relative './lib/display'

include Display

def play_game
  display_intro
  loop do
    Game.new.play
    return unless another_match?
  end
end

def another_match?
  loop do
    display_another_match
    case gets.chomp
    when '1'
      return true
    when '2'
      return false
    end
  end
end

play_game