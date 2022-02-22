# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

describe Game do
  subject(:game) { described_class.new }

  describe '#new_players' do
    it 'sets the new players (with their names) as game instance attributes' do
      allow(game.p1).to receive(:gets).and_return('Rufus')
      allow(game.p2).to receive(:gets).and_return('Fido')
      allow(game.p1).to receive(:puts)
      allow(game.p2).to receive(:puts)
      game.new_players
      expect(game.p1.name).to eq('Rufus')
      expect(game.p2.name).to eq('Fido')
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
      let(:player) { instance_double(Player, piece: 'x', turn_input: 5) }
      it 'sends message #drop_piece with argument 5 to the @board' do
        game.instance_variable_set(:@active_player, player)
        board = game.instance_variable_get(:@board)

        expect(board).to receive(:drop_piece).with(5, player.piece).once
        game.player_turn
      end
    end
  end
end
