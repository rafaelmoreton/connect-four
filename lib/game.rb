# frozen_string_literal: true

require_relative 'player'
require_relative 'board'

# Used to set up and store the game elements as instance attributes and to
# complete a whole match loop
class Game
  attr_reader :p1, :p2, :active_player

  def initialize
    @board = Board.new
    @p1 = Player.new("\033[36m\u25a0\033[0m")
    @p2 = Player.new("\033[35m\u25a0\033[0m")
    @active_player = nil
  end

  def new_players
    @p1.set_name
    @p2.set_name
  end

  def next_player
    @active_player =
      if @active_player == @p1
        @p2
      else
        @p1
      end
  end

  def player_turn
    target = @active_player.turn_input
    @board.drop_piece(target, @active_player.piece)
  end
end
