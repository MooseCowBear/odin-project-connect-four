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
    #loop over first row, record indices of any nils to array
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
  
  private

  def get_starting_board
    Array.new(6) { Array.new(7) }
  end
end