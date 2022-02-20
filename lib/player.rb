# frozen_string_literal: true

require_relative 'display'

class Player
  include Display
  attr_reader :name

  def set_name
    puts display_name_prompt(1)
    loop do
      player_input = gets.chomp
      unless player_input.empty?
        return @name = player_input
      else
        puts display_name_warn(1)
      end
    end
  end

  def turn_input
    puts display_turn_prompt(1)
    loop do
      player_input = gets.chomp.to_i
      if player_input >= 1 && player_input <= 7
        return player_input
      else
        puts display_turn_warn(1)
      end
    end
  end
end