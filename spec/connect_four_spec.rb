require_relative '../lib/connect_four.rb'

describe ConnectFour do
  describe '#initialize' do
    it 'calls get_starting_board' do

    end
  end

  describe '#get_starting_board' do
    subject(:starting_game) { described_class.new  }

    it 'returns an empty board' do
      empty_board = Array.new(6) { Array.new(7) } #should be 6 rows, 7 cols
      board = starting_game.board
      expect(board).to eq(empty_board)
    end
  end


end