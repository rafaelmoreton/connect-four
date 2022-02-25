# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

# rubocop:disable Metrics/BlockLength
describe Game do
  subject(:game) { described_class.new }

  describe '#new_players' do
    it 'sets the new players (with their names and colors) as game instance attributes' do
      allow(game.p1).to receive(:gets).and_return('Rufus')
      allow(game.p2).to receive(:gets).and_return('Fido')
      allow(game.p1).to receive(:puts)
      allow(game.p2).to receive(:puts)
      game.new_players
      expect(game.p1.name).to eq("\033[36mRufus\033[0m")
      expect(game.p2.name).to eq("\033[35mFido\033[0m")
    end
  end

  describe '#next_player' do
    context 'when the game as just started' do
      it 'makes p1 the @active_player' do
        game.next_player
        expect(game.active_player).to eq(game.p1)
      end
    end

    context 'when p1 is the current active player' do
      it 'makes p2 the @active_player' do
        game.instance_variable_set(:@active_player, game.p1)
        game.next_player
        expect(game.active_player).to eq(game.p2)
      end
    end
  end

  describe '#player_turn' do
    context 'when current @active_player is p1' do
      it 'sends message #turn_input to p1' do
        valid_input = 2 # Necessary to provide the valid input that will be
        # used by Board#find_bottom
        game.instance_variable_set(:@active_player, game.p1)
        expect(game.p1).to receive(:turn_input).and_return(valid_input)
        game.player_turn
      end
    end

    context "when player inputs '5'" do
      let(:player) { instance_double(Player, name: 'Rufus', piece: 'x', turn_input: 5) }
      it 'sends message #drop_piece with argument 5 to the @board' do
        game.instance_variable_set(:@active_player, player)
        board = game.instance_variable_get(:@board)

        expect(board).to receive(:drop_piece).with(5, player.piece).once
        game.player_turn
      end
    end
  end

  describe '#loop_turns' do
    it 'sends #game_over? to the board instance' do
      board = game.instance_variable_get(:@board)
      allow(game).to receive(:player_turn)
      allow(board).to receive(:game_over?).and_return(true)

      expect(board).to receive(:game_over?)
      game.loop_turns
    end

    context 'if it takes 7 turns for a line of 4 to be made' do
      it 'game instance receives #player_turn 7 times before the loop exits' do
        allow(game.p1).to receive(:turn_input).and_return(2)
        allow(game.p2).to receive(:turn_input).and_return(5)
        allow(game).to receive(:puts)
        allow(game.instance_variable_get(:@board)).to receive(:puts)

        expect(game).to receive(:player_turn).and_call_original.exactly(7).times
        game.loop_turns
      end
    end
  end

  describe '#result' do
    context 'when player 1 has completed a line' do
      it "announces player 1's victory" do
        name = 'Rufus'
        allow(game.p1).to receive(:name).and_return(name)
        game.instance_variable_set(:@active_player, game.p1)
        winner = game.active_player
        win_announcement = "#{winner.name} won the match!\n\n"

        expect { game.result }.to output(win_announcement).to_stdout
      end
    end

    context 'when no line was completed (game is over because board is full)' do
      it 'announces the draw' do
        board = game.instance_variable_get(:@board)
        allow(board).to receive(:full_board?).and_return(true)
        draw_announcement = "The board is full. This match has came to a draw\n"
        expect { game.result }.to output(draw_announcement).to_stdout
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
