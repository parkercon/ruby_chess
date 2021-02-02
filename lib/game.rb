require_relative 'board'
require_relative 'player'
require_relative 'colors'

class Game
  CYAN_BLOCK = '     '.bg_cyan
  RED_BLOCK = '     '.bg_red
  attr_accessor :player_one, :player_two

  def menu
    puts '\nHello, Welcome to my great chess game in progress!\nWhat would you like to do?\n'
    puts '(1) Player vs Player'
    puts '(2) Player vs Computer'
    puts '(3) Load a Game'
    input = gets.chomp #error handle

    case input

    when '1'
      play_game
    end
    
  end
  
  def switch_player(name)
    name == player_one.name ? player_two : player_one
  end

  def play_game
    puts 'chess stuff'
    @player_one = Player.new('parker', 'white')
    @player_two = Player.new('bop', 'black')
    @board = Board.new
    done = false
    player = player_one
    opponent = player_two
    until done == true do
      begin
        puts "#{player.name}, your turn!\n"
        @board.generate_board_visual
        puts @board.print_board(@player_one, @player_two)
        puts 'choose piece'
        start = @board.input_to_coord(gets.chomp)
        raise "Invalid input" if start.nil?
        puts 'where to'
        dest = @board.input_to_coord(gets.chomp) 
        raise "Invalid input" if dest.nil?
        raise "Invalid input, please select a valid cell" if player.find_piece_index(start[0], start[1]).nil?
        piece = player.pieces[player.find_piece_index(start[0], start[1])]
        raise "Invalid input, please ensure input is within bounds" if start.nil? || dest.nil?
        raise "Invalid move, not within the moveset" unless piece.valid_move?(dest)
        raise "Invalid move, pawn validation" if @board.pawn_validation(player, start, dest).nil?
        raise "Invalid move, can't go through pieces" if @board.conflict_check(player, opponent, start, dest).nil?
        rescue StandardError => e
          puts e.to_s.red
          retry
      end
        if !@board.update_board(player, opponent, start, dest).nil?
          opponent = player
          player = switch_player(player.name)
        end
    end
  end
end