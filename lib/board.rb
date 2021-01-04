require_relative 'player'
require_relative 'colors'
class Board
  BOARD_SIZE = 8
  CYAN_BLOCK = '     '.bg_cyan
  RED_BLOCK = '     '.bg_red
  attr_accessor :player_one, :player_two, :board_visual
  def initialize(name1, name2)
    @player_one = Player.new(name1, 'white')
    @player_two = Player.new(name2, 'black')
    @board_visual = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    @board_data = generate_board_data
    generate_board_visual
    
  end

  def letter_to_number(letter)
     alph = ("a".."z").to_a
    alph.each_with_index do |val, idx|
      if val == letter
        return idx
      end
    end
  end

  def valid_input?(input)
    input[0]
    input[1]
    alph = ("a".."h").to_a
    num = ("0".."7").to_a
    if input.length == 2 && alph.include?(input[0]) && num.include?(input[1])
      true
    else 
      false
    end
  end

  def input_to_coord(input)
    #CHECK VALID
    coordinates = Array.new(2)
    coordinates[0] = letter_to_number(input[0])
    coordinates[1] = input[1].to_i
    coordinates
  end
  
  def generate_board_data
    a = Array.new(BOARD_SIZE) { |index| index }
    board = []
    a.each do |row|
      a.each do |col|
        board.push([row,col])
      end 
    end 
    board
  end

  def generate_board_visual
    (0...BOARD_SIZE).each do |row|
      (0...BOARD_SIZE).each do |col|
        if row % 2 == 0
          if col % 2 == 0   
            board_visual[row][col] = CYAN_BLOCK
          else 
            board_visual[row][col] = RED_BLOCK
          end
        else 
          if col % 2 != 0
            board_visual[row][col] = CYAN_BLOCK
          else 
            board_visual[row][col] = RED_BLOCK
          end
        end
      end 
    end
  end

  def print_board
    puts "\n"
    (0...BOARD_SIZE).each do |row|
      print "       #{row} " 
      (0...BOARD_SIZE).each do |col|
        @player_one.pieces.each do |piece|
          if piece.x == row && piece.y == col
            @board_visual[row][col] = @board_visual[row][col] == CYAN_BLOCK ? "  #{piece.symbol}  ".bg_cyan : "  #{piece.symbol}  ".bg_red
          end
        end
        @player_two.pieces.each do |piece|
          if piece.x == row && piece.y == col
            @board_visual[row][col] = @board_visual[row][col] == CYAN_BLOCK ? "  #{piece.symbol}  ".bg_cyan.black : "  #{piece.symbol}  ".bg_red.black
          end
        end
        print "#{@board_visual[row][col]}"
      end
      print "\n"
    end 
    puts "           a    b    c    d    e    f    g    h"
    # @board_visual[data[0]][data[1]] = @board_visual[data[0]][data[1]] == "  #{piece.symbol}  ".bg_cyan ? CYAN_BLOCK : RED_BLOCK
  end 

  def update_board(input)
    #maybe change input here 
    row = 6
    col = 0
    #====where i would get input ======
    player_one.pieces[0].x = 5
    @board_visual[6][0] = @board_visual[6][0] == "  #{@player_one.pieces[0].symbol}  ".bg_cyan ? CYAN_BLOCK : RED_BLOCK
    generate_board_visual
    puts print_board
  end

end