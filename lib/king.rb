class King < Piece
  def initialize(x, y, color)
    @symbol = '♔'
    super(x, y, symbol, color)
    @moved = false
  end

  def get_valid_moves
    potentials = []
    potentials.push(
      [x, y + 1],
      [x, y - 1],
      [x + 1, y],
      [x - 1, y],
      [x + 1, y + 1],
      [x - 1, y - 1],
      [x + 1, y - 1],
      [x - 1, y + 1]
      )

    valid_children = potentials.select do |i|
      i[0].between?(0,7) &&
      i[1].between?(0,7)
    end
    valid_children
  end
end