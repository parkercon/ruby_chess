require_relative 'piece'
require_relative 'knight'
require_relative 'rook'
require_relative 'king'
require_relative 'queen'
require_relative 'pawn'
require_relative 'bishop'
class Player
  attr_accessor :name, :pieces
  def initialize(name, color)
    @name = name
    @pieces = color == 'white' ? generate_white_pieces : generate_black_pieces
  end
  
  def generate_white_pieces
    p_array = []
    x = 6
    8.times { |y| p_array << Pawn.new(x, y, 'white') }
    p_array << Rook.new(7, 0, 'white')
    p_array << Knight.new(7, 1, 'white')
    p_array << Bishop.new(7, 2, 'white')
    p_array << Queen.new(7, 3, 'white')
    p_array << King.new(7, 4, 'white')
    p_array << Bishop.new(7, 5, 'white')
    p_array << Knight.new(7, 6, 'white')
    p_array << Rook.new(7, 7, 'white')
    p_array
  end

  def generate_black_pieces
    p_array = []
    x = 1
    8.times { |y| p_array << Pawn.new(x, y, 'black') }
    p_array << Rook.new(0, 0, 'black')
    p_array << Knight.new(0, 1, 'black')
    p_array << Bishop.new(0, 2, 'black')
    p_array << Queen.new(0, 3, 'black')
    p_array << King.new(0, 4, 'black')
    p_array << Bishop.new(0, 5, 'black')
    p_array << Knight.new(0, 6, 'black')
    p_array << Rook.new(0, 7, 'black')
    p_array
  end
end