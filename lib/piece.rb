require_relative 'colors'
class Piece
  attr_accessor :x, :y, :symbol, :color
  def initialize(x, y, symbol, color)
    @x = x
    @y = y
    @symbol = symbol
    @color = color
  end

  # maybe delete
  # def to_s
  #   color == 'white' ? symbol : symbol.black
  # end
end