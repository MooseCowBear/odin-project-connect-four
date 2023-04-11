require_relative '../lib/connect_four.rb'

describe ConnectFour do
  describe '#initialize' do
    context 'when using default initialization' do
      subject(:starting_game) { described_class.new  }

      it 'default returns empty' do
        empty_board = Array.new(6) { Array.new(7) } 
        board = starting_game.board
        expect(board).to eq(empty_board)
      end

      it 'assigns curr_player to a random number 1 or 2' do
        start_player = starting_game.curr_player
        expect(start_player).to be_between(1, 2)
      end

      it 'assigns player1 to nil' do
        player = starting_game.player1
        expect(player).to be_nil
      end

      it 'assigns player2 to nil' do
        player = starting_game.player2
        expect(player).to be_nil
      end
    end
    
    context 'when specifying board state' do
      let(:board_state) { [[nil, "1"], ["1", "2"]] }
      subject(:not_default_game) { described_class.new(board_state) }

      it 'sets board to specified board' do
        board = not_default_game.board
        expect(board).to eq(board_state)
      end
    end

    context 'when also specifying curr_player' do
      let(:board_state) { [[nil, "1"], ["1", "2"]] }
      let(:set_curr_player) { 2 }
      subject(:not_default_game) { described_class.new(board_state, set_curr_player) }

      it 'equals 2' do
        player = not_default_game.curr_player
        expect(player).to eq(2)
      end
    end
  end


end