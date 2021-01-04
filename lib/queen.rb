require_relative 'piece'
class Queen < Piece
  def initialize(x, y, color)
    @symbol = '♕'
    super(x, y, symbol, color)
  end
end