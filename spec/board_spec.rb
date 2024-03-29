# frozen_string_literal: true

require_relative '../lib/board'

# rubocop:disable Metrics/BlockLength
describe Board do
  subject(:board) { described_class.new }

  describe '#find_bottom' do
    context 'when passed "5" as argument' do
      it 'returns index of bottom slot of column 5' do
        bottom_slot_index = board.find_bottom(5)
        expect(bottom_slot_index).to eq 39
      end
    end

    context 'when passed "7" as argument' do
      it 'returns index of bottom slot of column 7' do
        bottom_slot_index = board.find_bottom(7)
        expect(bottom_slot_index).to eq 41
      end
    end
  end

  describe '#drop_piece' do
    context 'when passed "3" as argument' do
      it 'fills the bottom slot of column "3"' do
        expect { board.drop_piece(3, 'x') }.to change { board.slots[37] }.from(38).to('x')
      end
      context 'if the bottom slot of the column is taken' do
        it 'fills the bottommost empty slot' do
          board.drop_piece(3, 'x')
          expect { board.drop_piece(3, 'x') }.to change { board.slots[30] }.from(31).to('x')
        end
      end
    end
  end

  describe '#game_over?' do
    context 'at game start' do
      it 'returns false' do
        result = board.game_over?
        expect(result).to be false
      end
    end

    context 'when the board is full, but there is no 4-pieces-line' do
      it 'returns false' do
        full_board = %w[
          o o x o o x o
          x x x o x o o
          x o x o x x o
          o x o x x o x
          o x o x o o x
          o o o x o o x
        ]
        board.instance_variable_set(:@slots, full_board)
        result = board.game_over?
        expect(result).to be false
      end
    end

    context 'when there is a 4-pieces-line' do
      it 'returns true' do
        4.times { board.drop_piece(2, 'x') }
        result = board.game_over?
        expect(result).to be true
      end
    end
  end

  describe '#row_win?' do
    context 'at game start' do
      it 'returns false' do
        result = board.row_win?
        expect(result).to be false
      end
    end

    context "after piece drops that don't lead to victory" do
      it 'returns false' do
        board.drop_piece(1, 'x')
        board.drop_piece(2, 'x')
        3.times { board.drop_piece(4, 'x') }
        board.drop_piece(6, 'x')
        board.drop_piece(7, 'x')
        result = board.row_win?
        expect(result).to be false
      end
    end

    context "when a 3-pieces-line at the end of the board could include a nil
    value in it's count, leading to false victory" do
      it 'returns false' do
        board.drop_piece(5, 'x')
        board.drop_piece(6, 'x')
        board.drop_piece(7, 'x')
        result = board.row_win?
        expect(result).to be false
      end
    end

    context 'when the ends of @slots could wrap, leading to false victory' do
      it 'returns false' do
        board.drop_piece(5, 'x')
        board.drop_piece(6, 'x')
        board.drop_piece(7, 'x')
        6.times { board.drop_piece(1, 'x') }
        6.times { board.drop_piece(2, 'x') }
        result = board.row_win?
        expect(result).to be false
      end
    end

    context 'when following a row count from the position of last play would
    wrap to another row inside board' do
      it 'returns false' do
        board.drop_piece(6, 'o')
        board.drop_piece(7, 'o')
        board.drop_piece(7, 'x')
        board.drop_piece(3, 'x')
        board.drop_piece(2, 'x')
        board.drop_piece(1, 'x')
        result = board.row_win?
        expect(result).to be false
      end
    end

    context 'when a 4-pieces-line is formed in a row' do
      it 'returns true' do
        board.drop_piece(4, 'x')
        board.drop_piece(5, 'x')
        board.drop_piece(6, 'x')
        board.drop_piece(7, 'x')
        result = board.row_win?
        expect(result).to be true
      end
    end

    context 'if the winning last play completes a 4-pieces-line by filling a
    gap betwen other pieces' do
      it 'returns true' do
        board.drop_piece(1, 'x')
        board.drop_piece(2, 'x')
        board.drop_piece(4, 'x')
        board.drop_piece(3, 'x')
        result = board.row_win?
        expect(result).to be true
      end
    end
  end

  describe '#column_win?' do
    context 'at game start' do
      it 'returns false' do
        result = board.column_win?
        expect(result).to be false
      end
    end

    context "after piece drops that don't lead to victory" do
      it 'returns false' do
        board.drop_piece(1, 'x')
        board.drop_piece(2, 'x')
        3.times { board.drop_piece(4, 'x') }
        board.drop_piece(6, 'x')
        board.drop_piece(7, 'x')
        result = board.column_win?
        expect(result).to be false
      end
    end

    context 'when the ends of @slots could wrap, leading to false victory' do
      it 'returns false' do
        3.times do
          board.drop_piece(1, 'x')
          board.drop_piece(2, 'x')
          board.drop_piece(3, 'x')
          board.drop_piece(5, 'x')
          board.drop_piece(6, 'x')
          board.drop_piece(7, 'x')
        end
        board.drop_piece(1, 'o')
        board.drop_piece(2, 'o')
        board.drop_piece(3, 'o')
        board.drop_piece(5, 'o')
        board.drop_piece(6, 'o')
        board.drop_piece(7, 'o')
        3.times do
          board.drop_piece(1, 'x')
          board.drop_piece(2, 'x')
          board.drop_piece(3, 'x')
          board.drop_piece(5, 'x')
          board.drop_piece(6, 'x')
          board.drop_piece(7, 'x')
        end
        result = board.column_win?
        expect(result).to be false
      end
    end

    context 'when a 4-pieces-line is formed in a column' do
      it 'returns true' do
        4.times { board.drop_piece(2, 'x') }
        result = board.column_win?
        expect(result).to be true
      end
    end
  end

  describe '#diagonal_win?' do
    context 'at game start' do
      it 'returns false' do
        result = board.diagonal_win?
        expect(result).to be false
      end
    end

    context "after piece drops that don't lead to victory" do
      it 'returns false' do
        board.drop_piece(2, 'o')
        board.drop_piece(3, 'o')
        board.drop_piece(4, 'o')
        board.drop_piece(4, 'o')
        board.drop_piece(4, 'x')
        board.drop_piece(3, 'x')
        2.times do
          board.drop_piece(5, 'x')
          board.drop_piece(6, 'x')
          board.drop_piece(7, 'x')
        end
        board.drop_piece(5, 'o')
        board.drop_piece(6, 'o')
        board.drop_piece(6, 'x')
        3.times do
          board.drop_piece(7, 'o')
        end
        result = board.diagonal_win?
        expect(result).to be false
      end
    end

    context 'when the ends of @slots could wrap, leading to false victory' do
      it 'returns false' do
        3.times do
          board.drop_piece(1, 'x')
          board.drop_piece(2, 'x')
          board.drop_piece(3, 'x')
          board.drop_piece(5, 'x')
          board.drop_piece(6, 'x')
          board.drop_piece(7, 'x')
        end
        board.drop_piece(1, 'o')
        board.drop_piece(2, 'o')
        board.drop_piece(3, 'o')
        board.drop_piece(5, 'o')
        board.drop_piece(6, 'o')
        board.drop_piece(7, 'o')
        3.times do
          board.drop_piece(1, 'x')
          board.drop_piece(2, 'x')
          board.drop_piece(3, 'x')
          board.drop_piece(5, 'x')
          board.drop_piece(6, 'x')
          board.drop_piece(7, 'x')
        end
        result = board.diagonal_win?
        expect(result).to be false
      end
    end

    context 'when following a diagonal count from the position of last play
    would wrap to another diagonal inside board' do
      it 'returns false' do
        board.drop_piece(1, 'x')
        3.times { board.drop_piece(7, 'x') }
        4.times { board.drop_piece(6, 'x') }

        board.drop_piece(1, 'o')
        board.drop_piece(2, 'o')
        board.drop_piece(6, 'o')
        board.drop_piece(7, 'o')

        result = board.diagonal_win?
        expect(result).to be false
      end
    end

    context 'when a 4-pieces-line is formed in a diagonal' do
      it 'returns true' do
        3.times { board.drop_piece(2, 'x') }
        2.times { board.drop_piece(3, 'x') }
        board.drop_piece(4, 'x')
        board.drop_piece(2, 'o')
        board.drop_piece(3, 'o')
        board.drop_piece(4, 'o')
        board.drop_piece(5, 'o')
        result = board.diagonal_win?
        expect(result).to be true
      end
    end

    context 'if the winning last play completes a 4-pieces-line by filling a
    gap betwen other pieces' do
      it 'returns true' do
        board.drop_piece(2, 'o')
        2.times { board.drop_piece(3, 'o') }
        3.times { board.drop_piece(4, 'o') }
        board.drop_piece(1, 'x')
        board.drop_piece(2, 'x')
        board.drop_piece(4, 'x')
        board.drop_piece(3, 'x')

        result = board.diagonal_win?
        expect(result).to be true
      end
    end

    context "when a 3-pieces-line at the end of the board could include a nil
    value in it's count, leading to false victory" do
      it 'returns false' do
        3.times { board.drop_piece(5, 'b') }
        4.times { board.drop_piece(6, 'c') }
        5.times { board.drop_piece(7, 'd') }
        board.drop_piece(5, 'x')
        board.drop_piece(6, 'x')
        board.drop_piece(7, 'x')
        result = board.diagonal_win?
        expect(result).to be false
      end
    end
  end

  describe '#show' do
    context 'at game start' do
      it 'outputs the empty board to the terminal console' do
        empty_board = <<~BOARD

          1|2|3|4|5|6|7
          □|□|□|□|□|□|□
          □|□|□|□|□|□|□
          □|□|□|□|□|□|□
          □|□|□|□|□|□|□
          □|□|□|□|□|□|□
          □|□|□|□|□|□|□
        BOARD
        expect { board.show }.to output(empty_board).to_stdout
      end
    end

    context 'when some plays have been made' do
      it 'outputs the board showing those plays' do
        played_board = <<~BOARD

          1|2|3|4|5|6|7
          □|□|□|□|□|□|□
          □|□|□|□|□|□|□
          □|□|□|□|□|□|□
          □|□|□|o|□|□|□
          □|□|□|o|□|□|□
          □|□|□|o|□|□|x
        BOARD
        board.drop_piece(7, 'x')
        3.times { board.drop_piece(4, 'o') }
        expect { board.show }.to output(played_board).to_stdout
      end
    end
  end

  describe '#full_board?' do
    context 'when the board is not full' do
      it 'returns false' do
        expect(board.full_board?).to be false
      end
    end

    context 'when some plays have been made' do
      it 'returns false' do
        board.drop_piece(7, 'x')
        3.times { board.drop_piece(4, 'o') }

        expect(board.full_board?).to be false
      end
    end

    context 'when the board is full' do
      it 'returns true' do
        full_board = %w[
          o o x o o x o
          x x x o x o o
          x o x o x x o
          o x o x x o x
          o x o x o o x
          o o o x o o x
        ]
        board.instance_variable_set(:@slots, full_board)
        expect(board.full_board?).to be true
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
