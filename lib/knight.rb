require_relative 'piece'
class Knight < Piece
  def initialize(x, y, color)
    @symbol = '♘'
    super(x, y, symbol, color)
  end
end