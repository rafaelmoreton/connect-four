# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'display'

# Used to set up and store the game elements as instance attributes and to
# complete a whole match loop
class Game
  include Display
  attr_reader :p1, :p2, :active_player

  def initialize
    @board = Board.new
    @p1 = Player.new("\033[36m\u25a0\033[0m")
    @p2 = Player.new("\033[35m\u25a0\033[0m")
    @active_player = nil
  end

  def play
    new_players
    loop_turns
    @board.show
    result
  end

  def new_players
    @p1.set_name(1)
    @p2.set_name(2)
    colorfull_names
  end

  def colorfull_names
    @p1.instance_variable_set(:@name, "\033[36m#{p1.name}\033[0m")
    @p2.instance_variable_set(:@name, "\033[35m#{p2.name}\033[0m")
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
    target = @active_player.turn_input(@board)
    @board.drop_piece(target, @active_player.piece)
  end

  def loop_turns
    loop do
      return if @board.game_over?
      return if @board.full_board?

      @board.show
      next_player
      player_turn
    end
  end

  def result
    return display_draw if @board.full_board?

    display_win(@active_player)
  end
end
