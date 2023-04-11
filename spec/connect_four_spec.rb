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

  describe 'available_columns' do
    context 'when there are available columns' do 
      let(:board_state) { [[nil, "1", "2"], ["1", "2", "1"]] }
      subject(:game_columns) { described_class.new(board_state) }

      it 'returns [0] when only nil appears in first row, first column' do
        available_columns = game_columns.available_columns
        expect(available_columns). to eq([0])
      end
    end

    context 'when there are no available columns' do
      let(:board_state) { [["2", "1", "2"], ["1", "2", "1"]] }
      subject(:game_columns) { described_class.new(board_state) }

      it 'returns [] when no nil appears in first row' do
        available_columns = game_columns.available_columns
        expect(available_columns). to eq([])
      end
    end
  end

  describe 'board_filled?' do
    context 'when the board is not filled' do
      let(:board_state) { [[nil, "1", "2"], ["1", "2", "1"]] }
      subject(:game_unfinished) { described_class.new(board_state) }

      it 'returns true' do
        filled = game_unfinished.board_filled?
        expect(filled).to be false
      end
    end

    context 'when the board is filled' do
      let(:board_state) { [["2", "1", "2"], ["1", "2", "1"]] }
      subject(:game_finished) { described_class.new(board_state) }

      it 'returns false' do
        filled = game_finished.board_filled?
        expect(filled).to be true
      end
    end
  end

  describe '#game_over?' do
    context 'when the board is filled' do
      let(:board_state) { [["2", "1", "2"], ["1", "2", "1"]] }
      subject(:game_finished) { described_class.new(board_state) }

      it 'returns true' do
        over = game_finished.game_over?
        expect(over).to be true
      end
    end

    context 'when the board is not filled, but there is a winner' do
      let(:set_winner) { double(name: "Frank") }
      let(:board_state) { [[nil, nil, "2"], ["1", "2", "1"]] }
      subject(:game_finished) { described_class.new(board_state) }

      it 'returns true' do
        game_finished.winner = set_winner
        over = game_finished.game_over?
        expect(over).to be true
      end
    end

    context 'when the board is not filled and there is no winner' do
      let(:board_state) { [[nil, nil, "2"], ["1", "2", "1"]] }
      subject(:game_unfinished) { described_class.new(board_state) }

      it 'returns false' do
        over = game_unfinished.game_over?
        expect(over).to be false
      end
    end
  end

  describe '#get_player' do 
    subject(:game_assign_player) { described_class.new }

    before do
      allow(game_assign_player).to receive(:gets).and_return("martin")
    end

    it 'returns a new player with the name provided' do
      new_player = game_assign_player.get_player(3)
      expect(new_player).to have_attributes(:name => "martin")
    end
  end
  
  describe '#convert_move' do
    context 'when first row is available' do
      let(:board_state) { [[nil, nil, nil], [nil, nil, nil]] }
      subject(:first_row_game) { described_class.new(board_state) }

      it 'returns [0, 1]' do
        converted_move = first_row_game.convert_move(1)
        expect(converted_move). to eq([1, 1])
      end
    end

    context 'when second row is available' do
      let(:board_state) { [[nil, nil, nil], [nil, "1", nil]] }
      subject(:second_row_game) { described_class.new(board_state) }

      it 'returns [1, 1]' do
        converted_move = second_row_game.convert_move(1)
        expect(converted_move). to eq([0, 1])
      end
    end
  end

  describe '#display_available_columns' do
    subject(:any_game) { described_class.new }
    it 'outputs correct phrase when there are columns available' do
      phrase = "Available columns are: 1, 2, 3, 4\n"
      cols = [0, 1, 2, 3]
      expect { any_game.display_available_columns(cols) }.to output(phrase).to_stdout
    end
  end
end