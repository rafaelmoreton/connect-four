# frozen_string_literal: true

# Used to create, manipulate and check an array structure with elements that
# represent the slots of the game board.
class Board
  attr_reader :slots, :last_play

  def initialize
    @slots = Array.new(42) { |i| i + 1 }
  end

  def drop_piece(column, piece)
    bottom_slot_index = find_bottom(column)
    @slots[bottom_slot_index] = piece
    @last_play = bottom_slot_index
  end

  def find_bottom(column)
    column_index = column - 1
    line_multiplier = 6
    6.times do
      line_multiplier -= 1
      bottom = @slots[column_index + (line_multiplier * 7)]
      return @slots.index(bottom) if bottom.instance_of?(Integer)
    end
  end

  def game_over?
    [row_win?, column_win?, diagonal_win?].any?(true)
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Style/EmptyElse
  def row_win?
    return false if defined?(@last_play).nil?

    right_row = []
    4.times do |i|
      right_row << @slots[@last_play + i]
    end

    left_row = []
    4.times do |i|
      left_row <<
        if (@last_play - i).positive?
          @slots[@last_play - i]
        else
          nil
        end
    end

    [right_row, left_row].any? do |winning_array|
      winning_array.uniq.length == 1
    end
  end

  def diagonal_win?
    return false if defined?(@last_play).nil?

    up_right_diagonal = []
    4.times do |i|
      up_right_diagonal <<
        if (@last_play - (i * 6)).positive?
          @slots[@last_play - (i * 6)]
        else
          nil
        end
    end

    up_left_diagonal = []
    4.times do |i|
      up_left_diagonal <<
        if (@last_play - (i * 8)).positive?
          @slots[@last_play - (i * 8)]
        else
          nil
        end
    end

    down_right_diagonal = []
    4.times do |i|
      down_right_diagonal << @slots[@last_play + (i * 8)]
    end

    down_left_diagonal = []
    4.times do |i|
      down_left_diagonal << @slots[@last_play + (i * 6)]
    end

    [up_right_diagonal, up_left_diagonal, up_right_diagonal, up_left_diagonal]
      .any? { |winning_array| winning_array.uniq.length == 1 }
  end
  # rubocop:enable Style/EmptyElse
  # rubocop:enable Metrics/MethodLength

  def column_win?
    return false if defined?(@last_play).nil?

    column = []
    4.times { |i| column << @slots[@last_play + (i * 7)] }
    column.uniq.length == 1
  end

  def show
    text_array = @slots.map.with_index do |slot, i|
      slot = "\u25a1" if slot.instance_of?(Integer)
      if i.zero?
        slot
      elsif (i % 7).zero?
        "\n#{slot}"
      else
        "|#{slot}"
      end
    end
    index = ["1|2|3|4|5|6|7\n"]
    text_array_with_index = index + text_array
    puts "\n#{text_array_with_index.join}"
  end
end

# "\033[35m\u25a0\033[0m" magenta piece
# "\033[36m\u25a0\033[0m" cyan piece
