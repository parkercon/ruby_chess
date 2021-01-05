require_relative 'piece'
class Pawn < Piece
  attr_accessor :moved
  def initialize(x, y, color)
    @symbol = '♙'
    super(x, y, symbol, color)
    @moved = false
  end

  def get_valid_moves
    potentials = []
    if !moved && color == 'black'
      potentials.push(
        [x + 1, y],
        [x + 2, y] 
      )
    elsif !moved && color == 'white'
      potentials.push(
        [x - 1, y],
        [x - 2, y] 
      )
    elsif moved && color == 'black'
      potentials.push(
        [x + 1, y],
      )
    elsif moved && color == 'white'
      potentials.push(
        [x - 1, y],
      )
    end
  end
end