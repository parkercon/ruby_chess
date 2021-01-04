class Bishop < Piece
  def initialize(x, y, color)
    @symbol = '♗'
    super(x, y, symbol, color)
  end
end