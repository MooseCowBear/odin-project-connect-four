require_relative '../lib/connect_four.rb'

describe ConnectFour do
  describe '#initialize' do
    subject(:starting_game) { described_class.new  }

    it 'default returns empty' do
      empty_board = Array.new(6) { Array.new(7) } 
      board = starting_game.board
      expect(board).to eq(empty_board)
    end

    
  end


end