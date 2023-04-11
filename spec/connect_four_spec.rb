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

  describe '#announce_starting_player' do
    context 'when starting player is player1' do
      let(:board_state) { Array.new(6) { Array.new(7) } }
      let(:player) { double(name: "jose") }
      subject(:first_starts_game) { described_class.new(board_state, 1) }

      it "outputs correct phrase with player1's name" do
        first_starts_game.player1 = player
        phrase = "Starting player is jose\n"
        expect { first_starts_game.announce_starting_player }.to output(phrase).to_stdout
      end
    end

    context 'when starting player is player2' do
      let(:board_state) { Array.new(6) { Array.new(7) } }
      let(:player) { double(name: "jesse") }
      subject(:second_starts_game) { described_class.new(board_state, 2) }

      it "outputs correct phrase with player2's name" do
        second_starts_game.player2 = player
        phrase = "Starting player is jesse\n"
        expect { second_starts_game.announce_starting_player }.to output(phrase).to_stdout
      end
    end
  end

  describe '#get_move' do
    let(:board_state) { [[nil, nil, nil], [nil, nil, nil]] }
    let(:player) { double(name: "Slagathor") }
    subject(:empty_game) { described_class.new(board_state, 1) }

    context 'when given a valid number' do
      before do
        allow(empty_game).to receive(:gets).and_return("1")
      end

      it 'calls gets once' do
        empty_game.player1 = player
        expect(empty_game).to receive(:gets).once
        empty_game.get_move
      end
    end

    context 'when given an invalid number, followed by a valid number' do
      before do
        allow(empty_game).to receive(:gets).and_return("100", "3")
      end

      it 'calls gets twice' do
        empty_game.player1 = player
        expect(empty_game).to receive(:gets).twice
        empty_game.get_move
      end
    end

    context 'when given a non-number, followed by a valid number' do
      before do
        allow(empty_game).to receive(:gets).and_return("b", "2")
      end

      it 'calls gets twice' do
        empty_game.player1 = player
        expect(empty_game).to receive(:gets).twice
        empty_game.get_move
      end
    end
  end

  describe '#winner?' do
    context 'when move completes a row' do
      let(:board_state) { 
        [
          [nil, nil, nil, nil],
          [nil, nil, nil, nil],
          ["X", "X", "X", "X"],
          ["X", "O", "O", "X"],
        ]
      }
      subject(:winning_row_game) { described_class.new(board_state, 1) }
      it 'returns true' do 
        move = [2, 0]
        won = winning_row_game.winner?(move)
        expect(won).to be true
      end
    end

    context 'when move completes a row by joining two parts' do
      let(:board_state) { 
        [
          [nil, nil, nil, nil],
          [nil, nil, nil, nil],
          ["X", "X", "X", "X"],
          ["X", "O", "O", "X"],
        ]
      }
      subject(:winning_row_game) { described_class.new(board_state, 1) }

      it 'returns true' do
        move = [2, 1]
        won = winning_row_game.winner?(move)
        expect(won).to be true
      end
    end

    context 'when move completes a column' do
      let(:board_state) { 
        [
          [nil, nil, nil, "X"],
          [nil, nil, nil, "X"],
          ["O", "X", "X", "X"],
          ["X", "O", "O", "X"],
        ]
      }
      subject(:winning_col_game) { described_class.new(board_state, 1) }

      it 'returns true' do 
        move = [0, 3]
        won = winning_col_game.winner?(move)
        expect(won).to be true
      end
    end

    context 'when move completes a left-right diagonal' do
      let(:board_state) { 
        [
          ["X", nil, nil, nil],
          ["O", "X", "O", "O"],
          ["O", "X", "X", "X"],
          ["X", "O", "O", "X"],
        ]
      }
      subject(:winning_diag_game) { described_class.new(board_state, 1) }

      it 'returns true' do 
        move = [0, 0]
        won = winning_diag_game.winner?(move)
        expect(won).to be true
      end
    end

    context 'when move completes a right-left diagonal' do
      let(:board_state) { 
        [
          [nil, nil, nil, "X"],
          [nil, nil, "X", "O"],
          ["O", "X", "X", "X"],
          ["X", "O", "O", "X"],
        ]
      }
      subject(:winning_diag_game) { described_class.new(board_state, 1) }

      it 'returns true' do 
        move = [0, 3]
        won = winning_diag_game.winner?(move)
        expect(won).to be true
      end
    end

    context 'when move does not complete any 4 next to each other' do
      let(:board_state) { 
        [
          [nil, nil, nil, nil],
          [nil, nil, nil, nil],
          ["X", "O", "X", "X"],
          ["X", "O", "O", "X"],
        ]
      }
      subject(:no_winning_game) { described_class.new(board_state, 1) }
      it 'returns false' do 
        move = [0, 2]
        won = no_winning_game.winner?(move)
        expect(won).to be false
      end
    end
  end

  describe '#display_turns' do
    subject(:any_game) { described_class.new }
    context 'when game_over? is false once' do
      before do 
        allow(any_game).to receive(:game_over?).and_return(false, true)
      end

      it 'calls take_turn once' do
        expect(any_game).to receive(:take_turn).once
        any_game.display_turns
      end
    end

    context 'when game_over? is false 3 times' do
      before do
        allow(any_game).to receive(:game_over?).and_return(false, false, false, true)
      end

      it 'calls take_turn 3 times' do
        expect(any_game).to receive(:take_turn).exactly(3).times
        any_game.display_turns
      end
    end
  end

  describe '#take_turn' do 
    subject(:game) { described_class.new }
    let(:player_one) { double(name: "jane") }
    let(:player_two) { double(name: "john") }
    
    before do
      allow(game).to receive(:get_move).and_return([0, 0])
      allow(game).to receive(:update_player_turn).and_return(2)
      allow(game).to receive(:winner?).with([0, 0]).and_return(true)
    end

    it 'calls get_move' do
      game.player1 = player_one
      game.player2 = player_two
      expect(game).to receive(:get_move).once
      game.take_turn
    end

    it 'calls update_board' do
      game.player1 = player_one
      game.player2 = player_two
      expect(game). to receive(:update_board).once
      game.take_turn
    end

    it 'calls winner?' do
      game.player1 = player_one
      game.player2 = player_two
      expect(game).to receive(:winner?).with([0, 0]).once.and_return(true)
      game.take_turn
    end

    it 'calls update_player_turn' do
      game.player1 = player_one
      game.player2 = player_two
      expect(game).to receive(:update_player_turn).once 
      game.take_turn
    end
    
    context 'when the game is won' do
      it 'calls record_winner' do
        game.player1 = player_one
        game.player2 = player_two
        expect(game).to receive(:record_winner).once
        game.take_turn
      end
    end
  end

  describe '#play' do 
    let(:board_state) { Array.new(6) { Array.new(7) } }
    subject(:game) { described_class.new(board_state, 1) }
    let(:player_one) { double(name: "winston") }
    let(:player_two) { double(name: "cassandra") }

    before do
      allow(game).to receive(:get_player).with(1).and_return(player_one)
      allow(game).to receive(:get_player).with(2).and_return(player_two)
      allow(game).to receive(:get_move).and_return([0, 0])
      allow(game).to receive(:update_player_turn).with(1, 2).and_return(2)
      allow(game).to receive(:winner?).with([0, 0]).and_return(true)
    end

    it 'calls get_player twice' do
      expect(game).to receive(:get_player).twice
      game.play
    end

    it 'calls display_turns' do
      expect(game).to receive(:display_turns).once
      game.play
    end

    it 'calls announce_result' do
      expect(game).to receive(:announce_result).once
      game.play
    end
  end
end