# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new }

  describe '#set_name' do
    context 'when a player inputs a non-empty string' do
      before do
        valid_input = 'Rufus'
        allow(player).to receive(:gets).and_return(valid_input)
        allow(player).to receive(:puts)
      end
      it "sets the player's name attribute" do
        player.set_name
        expect(player.name).to eq 'Rufus'
      end
    end

    context 'when a player inputs an empty string, then a valid input' do
      before do
        invalid_input = ''
        valid_input = 'Rufus'
        allow(player).to receive(:gets).and_return(invalid_input, valid_input)
      end
      it "repeats the loop twice" do
        expect(player).to receive(:puts).twice
        player.set_name
      end
    end
  end

  describe '#turn_input' do
    context 'when a player enters a valid input' do
      # it is necessary to provide valid_input as a string the, since it's what
      # the method's gets expects, and then at the end to expect the same valid
      # input as a integer, since this is the method's expected behavior.
      valid_input = rand(1..7).to_s
      before do
        allow(player).to receive(:gets).and_return(valid_input)
        allow(player).to receive(:puts)
      end
      it 'returns the valid input' do
        result = player.turn_input
        expect(result).to eq(valid_input.to_i)
      end
    end

    context 'when a player enters a invalid, then a valid input' do
      invalid_input = '9'
      valid_input = rand(1..7).to_s
      before do
        allow(player).to receive(:gets).and_return(invalid_input, valid_input)
        allow(player).to receive(:puts)
      end
      it 'repeats the loop twice' do
        expect(player).to receive(:puts).twice
        player.turn_input
      end
      it 'then returns the valid input' do
        result = player.turn_input
        expect(result).to eq(valid_input.to_i)
      end
    end
  end
end