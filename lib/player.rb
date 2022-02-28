# frozen_string_literal: true

require_relative 'display'

# Used to get players's inputs for Board#drop_piece
class Player
  include Display
  attr_reader :name, :piece

  def initialize(piece)
    @piece = piece
  end

  def set_name(player)
    puts display_name_prompt(player)
    loop do
      player_input = gets.chomp
      return @name = player_input unless player_input.empty?

      puts display_name_warn(player)
    end
  end

  def turn_input(board)
    puts display_turn_prompt(name)
    loop do
      player_input = gets.chomp.to_i
      if player_input >= 1 && player_input <= 7 && board.slots[player_input - 1]
                                                        .instance_of?(Integer)
        return player_input
      end
      puts display_turn_warn(player_input)
    end
  end
end
