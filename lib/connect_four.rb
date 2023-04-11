require_relative './board_game.rb'
require_relative './player.rb'

class ConnectFour
  include BoardGame

  attr_accessor :player1, :player2, :board, :curr_player, :winner

  def initialize(board = get_starting_board, curr_player = rand(1..2))
    @winner = nil
    @player1 = nil
    @player2 = nil
    @board = board
    @curr_player = curr_player
  end

  def display_turns
    take_turn until game_over?
  end

  def take_turn
    puts "The current board is: "
    print_board
    move = get_move
    update_board(board, move, get_mark)
    self.curr_player = update_player_turn(curr_player, 2)
    game_winner = winner?(move)
    record_winner if game_winner
  end

  def winner?(move)
    winning_row?(move) || winning_col?(move) || winning_diag?(move)
  end

  def get_move
    player = curr_player < 2 ? player1 : player2
    available = available_columns
    loop do 
      puts "Enter move for #{player.name}: " 
      move = gets.chomp.to_i
      if available.include?(move - 1)
        move = convert_move(move) 
        return move
      end
      display_available_columns(available)
    end
  end

  def display_available_columns(available)
    available = available.map { |elem| elem + 1 }
    available = available.join(", ")
    puts "Available columns are: " + available
  end

  def convert_move (col)
    #takes column choice, converts to [row, column]
    board.to_enum.with_index.reverse_each do |row, index| 
      if row[col].nil?
        return [index, col]
      end
    end
  end

  def get_player(player_num)
    puts "Enter name for Player #{player_num}:"
    player_name = gets.chomp
    Player.new(player_name)
  end

  def available_columns
    available = []
    board[0].each_with_index do |elem, index|
      available << index if elem.nil?
    end
    available
  end

  def board_filled?
    available_columns.empty?
  end

  def game_over?
    board_filled? || !winner.nil?
  end

  def print_board
    puts "| 1 | 2 | 3 | 4 | 5 | 6 | 7 |"
    board.each do |row|
      row_as_string = "|"
      row.each do |elem| 
        add = elem.nil? ? "   |" : ` #{elem} |`
        row_as_string += add
      end
      puts row_as_string
    end
  end
  
  private

  def get_mark #player1 is "X" -- temp
    curr_player > 1 ? "O" : "X"
  end

  def get_starting_board
    Array.new(6) { Array.new(7) }
  end

  def winning_row?(move)
    x, y = move
    mark = get_mark
    count = 0

    while y > -1
      if board[x][y] == mark
        count += 1
        y -= 1
      else
        break
      end
    end

    y = move[1] + 1

    while y < 7
      if board[x][y] == mark
        count += 1
        y += 1
      else
        break
      end
    end
    count >= 4
  end

  def winning_col?(move)
    x, y = move
    mark = get_mark

    count = 0
    
    while x < board.length
      if board[x][y] == mark
        count += 1
        x += 1
      else
        break
      end
    end
    count >= 4
  end

  def winning_diag?(move)
    left_right_diag?(move) || right_left_diag?(move)
  end

  def left_right_diag?(move)
    x, y = move
    mark = get_mark
    count = 0

    while x < board.length && y < board[0].length
      if board[x][y] == mark
        count += 1
        x += 1
        y += 1
      else
        break
      end
    end
    count >= 4
  end

  def right_left_diag?(move)
    x, y = move
    mark = get_mark
    count = 0

    while x < board.length && y > -1
      if board[x][y] == mark
        count += 1
        x += 1
        y -= 1
      else
        break
      end
    end
    count >= 4
  end

  def record_winner
    self.winner = curr_player > 1 ? player1 : player2 #curr player will be one ahead of winner if there is one
  end

  def announce_result
    if winner 
      puts "Congratulations, #{winner.name}!"
    else
      puts "It's a draw"
    end
  end
end