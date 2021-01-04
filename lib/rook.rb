require_relative 'piece'
class Rook < Piece
  def initialize(x, y, color)
    @symbol = '♖'
    super(x, y, symbol, color)
  end
end