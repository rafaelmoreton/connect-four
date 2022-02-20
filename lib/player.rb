# frozen_string_literal: true

class Player
  attr_reader :name

  def set_name
    puts
    loop do
      player_input = gets.chomp
      unless player_input.empty?
        return @name = player_input
      else
        puts
      end
    end
  end

  def turn_input
    puts
    loop do
      player_input = gets.chomp.to_i
      if player_input >= 1 && player_input <= 7
        return player_input
      else
        puts
      end
    end
  end
end