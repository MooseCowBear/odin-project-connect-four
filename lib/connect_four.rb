
class ConnectFour
  attr_accessor :player1, :player2, :board, :curr_player, :winner

  def initialize(board = get_starting_board, curr_player = rand(1..2))
    @winner = nil
    @player1 = nil
    @player2 = nil
    @board = board
    @curr_player = curr_player
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