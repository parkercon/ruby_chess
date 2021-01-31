require_relative 'player'
require_relative 'colors'
class Board
  BOARD_SIZE = 8
  CYAN_BLOCK = '     '.bg_cyan
  RED_BLOCK = '     '.bg_red
  attr_accessor :player_one, :player_two, :board_visual
  def initialize
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
    return nil unless valid_input?(input)
    coordinates = Array.new(2)
    coordinates[0] = input[1].to_i
    coordinates[1] = letter_to_number(input[0])
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

  def print_board(player_one, player_two)
    puts "\t\t\t    a    b    c    d    e    f    g    h"
    (0...BOARD_SIZE).each do |row|
      print "\t\t\t#{row} " 
      (0...BOARD_SIZE).each do |col|
        player_one.pieces.each do |piece|
          if piece.x == row && piece.y == col
            @board_visual[row][col] = @board_visual[row][col] == CYAN_BLOCK ? "  #{piece.symbol}  ".bg_cyan : "  #{piece.symbol}  ".bg_red
          end
        end
        player_two.pieces.each do |piece|
          if piece.x == row && piece.y == col
            @board_visual[row][col] = @board_visual[row][col] == CYAN_BLOCK ? "  #{piece.symbol}  ".bg_cyan.black : "  #{piece.symbol}  ".bg_red.black
          end
        end
        print "#{@board_visual[row][col]}"
      end
      print " #{row} "
      print "\n"
    end 
    puts "\t\t\t    a    b    c    d    e    f    g    h"
    # @board_visual[data[0]][data[1]] = @board_visual[data[0]][data[1]] == "  #{piece.symbol}  ".bg_cyan ? CYAN_BLOCK : RED_BLOCK
  end 

  def pawn_validation(player, start, dest)
    idx = player.find_piece_index(start[0], start[1])
    if !player.pieces[idx].is_a? Pawn
      return 'bop'
    end
    if start[1] == dest[1]
      if @board_visual[dest[0]][dest[1]] != CYAN_BLOCK && @board_visual[dest[0]][dest[1]] != RED_BLOCK
        return nil
      end
    elsif start[1] != dest[1]
      if @board_visual[dest[0]][dest[1]] == CYAN_BLOCK && @board_visual[dest[0]][dest[1]] == RED_BLOCK
        return nil
      end
    end
    1
  end

#to make sure pieces to go through other pieces (except knight), could clean up
  def conflict_check(player, opponent, start, dest)
    idx = player.find_piece_index(start[0], start[1])
    opp_idx = opponent.find_piece_index(dest[0], dest[1])
    p start
    p dest
    p idx
    p "o #{opp_idx}"
    if player.pieces[idx].is_a? Knight
      return 'bo'
    end
    if player.pieces[idx].is_a? Pawn
      return 'bo'
    end
    copy_start = start.dup #shallow copy!!!
    copy_dest = dest.dup
    if (copy_start[0] < copy_dest[0] && copy_start[1] < copy_dest[1])
      p '1'
      until copy_start == copy_dest do
        copy_start[0] += 1
        copy_start[1] += 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1]
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] > copy_dest[0] && copy_start[1] > copy_dest[1])
      p '2'
      p copy_dest
      p copy_start
      p opp_idx
      until copy_start == copy_dest do
        copy_start[0] -= 1
        copy_start[1] -= 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1]
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          p 'got here'
          return nil
        end
      end
    elsif (copy_start[0] < copy_dest[0] && copy_start[1] > copy_dest[1])
      p '3'
      until copy_start == copy_dest do
        copy_start[0] += 1
        copy_start[1] -= 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1]
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] > copy_dest[0] && copy_start[1] < copy_dest[1])
      p '4'
      until copy_start == copy_dest do
        copy_start[0] -= 1
        copy_start[1] += 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1]
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] < copy_dest[0] && copy_start[1] == copy_dest[1])
      p '5'
      until copy_start[0] == copy_dest[0] do
        copy_start[0] += 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1]
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] > copy_dest[0] && copy_start[1] == copy_dest[1])
      p '6'
      until copy_start[0] == copy_dest[0] do
        copy_start[0] -= 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1]
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] == copy_dest[0] && copy_start[1] < copy_dest[1])
      p'7'
      until copy_start[1] == copy_dest[1] do
        copy_start[1] += 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1]
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] == copy_dest[0] && copy_start[1] > copy_dest[1])
      p '8'
      until copy_start[1] == copy_dest[1] do
        copy_start[1] -= 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1]
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    end
    return 'boo'
  end

  def in_check?(player, opponent, start)
    king_index = nil
    opponent.pieces.each_with_index{ |val, index| king_index = index if val.is_a? King }
    dest = Array.new(2)
    dest[0] = opponent.pieces[king_index].x
    dest[1] = opponent.pieces[king_index].y
    p "start: #{start}"
    p "dest: #{dest}"
    p "kidx: #{king_index}"
    conflict_check(player, opponent, start, dest) == 'bop' #need to work on to test for check
  end

  def moved_into_check?(player, opponent, dest)
    start = Array.new(2)
    opponent.pieces.each do |piece|
      start[0] = piece.x
      start[1] = piece.y#could clean up
      if conflict_check(opponent, player, start, dest) == 'bop'
        p "MOVED INTO CHECK" #Finish this check
      end
    end
  end

  def update_board(player, opponent, start, dest) #need to change to allow multiple players
    idx = player.find_piece_index(start[0], start[1])
    opp_idx = opponent.find_piece_index(dest[0], dest[1])
    player.pieces[idx].x = dest[0]
    player.pieces[idx].y = dest[1]
    if !opp_idx.nil?
      print "\nPiece Captured!\n"
      opponent.pieces.slice!(opp_idx) #to remove opponent pieces
    end
    @board_visual[start[0]][start[1]] = @board_visual[start[0]][start[1]] == "  #{player.pieces[idx].symbol}  ".bg_cyan ? CYAN_BLOCK : RED_BLOCK
    if player.pieces[idx].is_a? Pawn
      player.pieces[idx].moved = true
    elsif player.pieces[idx].is_a? King
      player.pieces[idx].moved = true
    elsif player.pieces[idx].is_a? Rook
      player.pieces[idx].moved = true
    end
    #make this a method
    p "check: #{in_check?(player, opponent, dest)}"
    if in_check?(player, opponent, dest)
      p "#{opponent.name} is in check"
    # elsif in_check?(opponent, player, dest)
    #   p "#{opponent.name} is in check"
    end
    idx2 = player.find_piece_index(dest[0], dest[1])
    if player.pieces[idx2].is_a? King
      if moved_into_check?(player, opponent, dest)
        print "\nInvalid, Cannot move into check\n".red
        player.pieces[idx].x = start[0]
        player.pieces[idx].y = start[1]
        return nil
      end
    end
    generate_board_visual
  end
end