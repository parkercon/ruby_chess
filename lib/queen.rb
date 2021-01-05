require_relative 'piece'
class Queen < Piece
  def initialize(x, y, color)
    @symbol = '♕'
    super(x, y, symbol, color)
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
      [x, y - 7],
      [x + 1, y + 1],
      [x + 2, y + 2],
      [x + 3, y + 3],
      [x + 4, y + 4],
      [x + 5, y + 5],
      [x + 6, y + 6],
      [x + 7, y + 7],
      [x - 1, y + 1],
      [x - 2, y + 2],
      [x - 3, y + 3],
      [x - 4, y + 4],
      [x - 5, y + 5],
      [x - 6, y + 6],
      [x - 7, y + 7],
      [x + 1, y - 1],
      [x + 2, y - 2],
      [x + 3, y - 3],
      [x + 4, y - 4],
      [x + 5, y - 5],
      [x + 6, y - 6],
      [x + 7, y - 7],
      [x - 1, y - 1],
      [x - 2, y - 2],
      [x - 3, y - 3],
      [x - 4, y - 4],
      [x - 5, y - 5],
      [x - 6, y - 6],
      [x - 7, y - 7]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,7) &&
      i[1].between?(0,7)
    end
    valid_children
  end
end