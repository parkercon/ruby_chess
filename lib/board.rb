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
    opp_king_idx = nil
    opponent.pieces.each_with_index{ |val, index| opp_king_idx = index if val.is_a? King }

    copy_start = start.dup #shallow copy!!!
    copy_dest = dest.dup
    if player.pieces[idx].is_a? Knight #need to check for check
      player.pieces.each do |piece|
        if dest[0] == piece.x && dest[1] == piece.y
          return nil
        end
      end
      pos_moves = player.pieces[idx].get_valid_moves
      pos_moves.each do |move|
        if move[0] == opponent.pieces[opp_king_idx].x && move[1] == opponent.pieces[opp_king_idx].y
          return 'bop'
        end 
      end
      return 'bo'
    end

    if player.pieces[idx].is_a? Pawn #need to check for check
      player.pieces.each do |piece|
        if dest[0] == piece.x && dest[1] == piece.y
          return nil
        end
      end
      pos_moves = player.pieces[idx].get_valid_moves
      pos_moves.each do |move|
        if move[0] == opponent.pieces[opp_king_idx].x && move[1] == opponent.pieces[opp_king_idx].y && move[1] != start[1]
          return 'bop'
        end 
      end
      return 'bo'
    end
      
    if (copy_start[0] < copy_dest[0] && copy_start[1] < copy_dest[1])
      until copy_start == copy_dest do
        copy_start[0] += 1
        copy_start[1] += 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1] && player.pieces[idx].valid_move?(dest)
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] > copy_dest[0] && copy_start[1] > copy_dest[1])
      until copy_start == copy_dest do
        copy_start[0] -= 1
        copy_start[1] -= 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1] && player.pieces[idx].valid_move?(dest)
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] < copy_dest[0] && copy_start[1] > copy_dest[1])
      until copy_start[0] == copy_dest[0] do
        copy_start[0] += 1
        copy_start[1] -= 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1] && player.pieces[idx].valid_move?(dest)
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] > copy_dest[0] && copy_start[1] < copy_dest[1])
      until copy_start == copy_dest do
        copy_start[0] -= 1
        copy_start[1] += 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1] && player.pieces[idx].valid_move?(dest)
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] < copy_dest[0] && copy_start[1] == copy_dest[1])
      until copy_start[0] == copy_dest[0] do
        copy_start[0] += 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1] && player.pieces[idx].valid_move?(dest)
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] > copy_dest[0] && copy_start[1] == copy_dest[1])
      until copy_start[0] == copy_dest[0] do
        copy_start[0] -= 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1] && player.pieces[idx].valid_move?(dest)
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] == copy_dest[0] && copy_start[1] < copy_dest[1])
      until copy_start[1] == copy_dest[1] do
        copy_start[1] += 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1] && player.pieces[idx].valid_move?(dest)
            return 'bop'
          end
        end
        if @board_visual[copy_start[0]][copy_start[1]] != CYAN_BLOCK && @board_visual[copy_start[0]][copy_start[1]] != RED_BLOCK
          return nil
        end
      end
    elsif (copy_start[0] == copy_dest[0] && copy_start[1] > copy_dest[1])
      until copy_start[1] == copy_dest[1] do
        copy_start[1] -= 1
        if copy_start == copy_dest && !opp_idx.nil?
          if opponent.pieces[opp_idx].x == dest[0] && opponent.pieces[opp_idx].y == dest[1] && player.pieces[idx].valid_move?(dest)
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
    conflict_check(player, opponent, start, dest) == 'bop' #need to work on to test for check
  end

  def moved_into_check?(player, opponent, dest)
    start = Array.new(2)
    opponent.pieces.each do |piece|
      start[0] = piece.x
      start[1] = piece.y#could clean up
      if conflict_check(opponent, player, start, dest) == 'bop'
        return true
      end
    end
    false
  end

  def king_vulnerable?(player, opponent)
    king_index = nil
    player.pieces.each_with_index{ |val, index| king_index = index if val.is_a? King }
    pos = Array.new(2)
    king_pos = Array.new(2)
    king_pos[0] = player.pieces[king_index].x
    king_pos[1] = player.pieces[king_index].y
    opponent.pieces.each do |piece|
      pos[0] = piece.x
      pos[1] = piece.y
      if conflict_check(opponent, player, pos, king_pos) == 'bop'
        return true
      end
    end
    false
  end

  def can_king_escape?(opponent, player)
    pos_moves = Array.new
    king_index = nil
    player.pieces.each_with_index{ |val, index| king_index = index if val.is_a? King }
    king_pos = Array.new(2)
    king_pos[0] = player.pieces[king_index].x
    king_pos[1] = player.pieces[king_index].y

    player.pieces[king_index].get_valid_moves.each do |move|
      if !conflict_check(player, opponent, king_pos, move).nil? && !moved_into_check?(player, opponent, move)
        pos_moves << move
      end
    end

    i = 0
    opponent.pieces.each do |piece|
      pos_moves.each do |move|
        if piece.get_valid_moves.include?(move) #need to make sure it can get too king
          i += 1
        end
      end
    end
    i != pos_moves.size 
  end

  def can_piece_protect?(opponent, player)
    pos_moves = Array.new
    king_index = nil
    player.pieces.each_with_index{ |val, index| king_index = index if val.is_a? King }
    king_pos = Array.new(2)
    king_pos[0] = player.pieces[king_index].x
    king_pos[1] = player.pieces[king_index].y
    p player.pieces[king_index].get_valid_moves
    player.pieces[king_index].get_valid_moves.each do |move|
      if !conflict_check(player, opponent, king_pos, move).nil? && !moved_into_check?(player, opponent, move)
        pos_moves << move
      end
    end

    start = Array.new(2)
    player.pieces.each do |piece|
      pos_moves.each do |move|
        start[0] = piece.x
        start[1] = piece.y
        if piece.get_valid_moves.include?(move) && !conflict_check(player, opponent, start, move).nil? && !piece.is_a?(King)
          return true
        end
      end
    end
    false
  end 

  def checkmate?(opponent, player)
    !can_piece_protect?(opponent, player) && !can_king_escape?(opponent, player)
  end

  def upgrade(player, idx, color)
    begin
    puts "Congrats, what would you like to upgrade your pawn to\n"
    puts "(1)Knight"
    puts "(2)Queen"
    puts "(3)Rook"
    puts "(4)Bishop"
    input = gets.chomp
    raise 'Invalid Input, try again' if input != '1' && input != '2' && input != '3' && input != '4'
    rescue StandardError => e
      puts e.to_s.red
      retry
    end

    x = player.pieces[idx].x
    y = player.pieces[idx].y
    player.pieces.slice!(idx)

    case input
    when '1'
      player.pieces << Knight.new(x, y, color)
    when '2'
      player.pieces << Queen.new(x, y, color)
    when '3'
      player.pieces << Rook.new(x, y, color)
    when '4'
      player.pieces << Bishop.new(x, y, color)
    end
  end

  def pawn_promotion(player)
    if player.pieces[0].color == 'white'
      player.pieces.each_with_index do |piece, idx|
        if piece.is_a?(Pawn)
          piece.x == 0 ? upgrade(player, idx, 'white') : next
        end
      end
    elsif player.pieces[0].color == 'black'
      player.pieces.each_with_index do |piece, idx|
        if piece.is_a?(Pawn)
          piece.x == 7 ? upgrade(player, idx, 'black') : next
        end
      end
    end
  end

  def update_board(player, opponent, start, dest) #need to change to allow multiple players
    idx = player.find_piece_index(start[0], start[1])
    opp_idx = opponent.find_piece_index(dest[0], dest[1])
    player.pieces[idx].x = dest[0]
    player.pieces[idx].y = dest[1]
    if !opp_idx.nil?
      print "\nPiece Captured!\n".green
      copy_piece = opponent.pieces[opp_idx]
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

    pawn_promotion(player)
    
    if in_check?(player, opponent, dest)
      puts "#{opponent.name} is in check".cyan
      can_piece_protect?(player, opponent)
      return 'checkmate' if checkmate?(player, opponent)
    end

    #temp change to allow pieces the ability to protect the king
    board_visual[dest[0]][dest[1]] = @board_visual[dest[0]][dest[1]] == CYAN_BLOCK ? "  #{player.pieces[idx].symbol}  ".bg_cyan : "  #{player.pieces[idx].symbol}  ".bg_red
    idx2 = player.find_piece_index(dest[0], dest[1])
    if player.pieces[idx2].is_a? King
      if moved_into_check?(player, opponent, dest) 
        print "\nInvalid, Cannot move into check\n".red
        player.pieces[idx].x = start[0]
        player.pieces[idx].y = start[1]
        opponent.pieces << copy_piece
        return nil
      end
    end

    if king_vulnerable?(player, opponent)
      print "\nInvalid, Cannot put your own king into check\n".red
      player.pieces[idx].x = start[0]
      player.pieces[idx].y = start[1]
      opponent.pieces << copy_piece
      return nil
    end
    @board_visual[dest[0]][dest[1]] = @board_visual[dest[0]][dest[1]] == "  #{player.pieces[idx].symbol}  ".bg_cyan ? CYAN_BLOCK : RED_BLOCK

    generate_board_visual
  end
end