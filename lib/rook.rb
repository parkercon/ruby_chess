require_relative 'piece'
class Rook < Piece
  def initialize(x, y, color)
    @symbol = '♖'
    super(x, y, symbol, color)
    @moved = false
  end

  def get_valid_moves
    potentials = []
    potentials.push(
      [x + 1, y],
      [x + 2, y],
      [x + 3, y],
      [x + 4, y],
      [x + 5, y],
      [x + 6, y],
      [x + 7, y],
      [x, y + 1],
      [x, y + 2],
      [x, y + 3],
      [x, y + 4],
      [x, y + 5],
      [x, y + 6],
      [x, y + 7],
      [x - 1, y],
      [x - 2, y],
      [x - 3, y],
      [x - 4, y],
      [x - 5, y],
      [x - 6, y],
      [x - 7, y],
      [x, y - 1],
      [x, y - 2],
      [x, y - 3],
      [x, y - 4],
      [x, y - 5],
      [x, y - 6],
      [x, y - 7]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,8) &&
      i[1].between?(0,8)
    end
    valid_children
  end
end