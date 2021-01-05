require_relative 'piece'
class Knight < Piece
  def initialize(x, y, color)
    @symbol = '♘'
    super(x, y, symbol, color)
  end

  def get_valid_moves
    potentials = []
    potentials.push(
      [x + 2, y + 1],
      [x + 2, y - 1],
      [x + 1, y + 2],
      [x + 1, y - 2],
      [x - 2, y + 1],
      [x - 2, y - 1], 
      [x - 1, y + 2], 
      [x - 1, y - 2]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,7) &&
      i[1].between?(0,7)
    end
    valid_children
  end
end