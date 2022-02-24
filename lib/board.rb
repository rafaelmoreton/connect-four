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
  def row_win?
    return false if defined?(@last_play).nil?

    count_up = []
    i = 0
    until @slots[@last_play + i] != @slots[@last_play]
      count_up << @slots[@last_play + i]
      i += 1
    end
    count_down = []
    i = 1 # So that it doesn't start counting from 0 and include itself again
    until @slots[@last_play - i] != @slots[@last_play]
      count_down << @slots[@last_play - i] if (@last_play - i).positive?
      i += 1
    end
    max_line = count_up + count_down
    return true if max_line.length >= 4

    false
  end

  def diagonal_win?
    return false if defined?(@last_play).nil?

    count_up_right = []
    i = 0
    until @slots[@last_play - (i * 6)] != @slots[@last_play]
      count_up_right << @slots[@last_play - (i * 6)] if (@last_play - (i * 6))
                                                        .positive?
      i += 1
    end
    count_down_left = []
    i = 1
    until @slots[@last_play + (i * 6)] != @slots[@last_play]
      count_down_left << @slots[@last_play + (i * 6)]
      i += 1
    end
    max_line_a = count_up_right + count_down_left
    return true if max_line_a.length >= 4

    count_up_left = []
    i = 0
    until @slots[@last_play - (i * 8)] != @slots[@last_play]
      count_up_left << @slots[@last_play - (i * 8)] if (@last_play - (i * 8))
                                                       .positive?
      i += 1
    end
    count_down_right = []
    i = 1
    until @slots[@last_play + (i * 8)] != @slots[@last_play]
      count_down_right << @slots[@last_play + (i * 8)]
      i += 1
    end
    max_line_b = count_up_left + count_down_right
    return true if max_line_b.length >= 4

    false
  end
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
