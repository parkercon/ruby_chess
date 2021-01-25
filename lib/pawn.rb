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
        [x + 2, y],
        [x + 1, y + 1],
        [x + 1, y - 1]
      )
    elsif !moved && color == 'white'
      potentials.push(
        [x - 1, y],
        [x - 2, y],
        [x - 1, y + 1],
        [x - 1, y - 1]
      )
    elsif moved && color == 'black'
      potentials.push(
        [x + 1, y],
        [x + 1, y + 1],
        [x + 1, y - 1]
      )
    elsif moved && color == 'white'
      potentials.push(
        [x - 1, y],
        [x - 1, y + 1],
        [x - 1, y - 1]
      )
    end
  end
end