
class ConnectFour
  attr_accessor :player1, :player2, :board, :curr_player

  def initialize(player1 = nil, player2 = nil, board = get_starting_board, curr_player = rand(1..2))
    @winner = nil
    @player1 = player1
    @player2 = player2
    @board = board
    @curr_player = curr_player
  end

  
  private

  def get_starting_board
    Array.new(6) { Array.new(7) }
  end
end