require_relative 'colors'
class Piece
  attr_accessor :x, :y, :symbol, :color
  def initialize(x, y, symbol, color)
    @x = x
    @y = y
    @symbol = symbol
    @color = color
  end

  def get_valid_moves; nil end

  def valid_move?(dest)
    get_valid_moves.include? dest
  end
  
end