require_relative 'board'
require_relative 'player'
require_relative 'colors'

class Game
  CYAN_BLOCK = '     '.bg_cyan
  RED_BLOCK = '     '.bg_red
  attr_accessor :player_one, :player_two
  
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
    until done == true do
      begin
        puts "#{player.name}, your turn!\n"
        @board.generate_board_visual
        puts @board.print_board(@player_one, @player_two)
        puts 'choose piece'
        start = @board.input_to_coord(gets.chomp) #check valid
        puts 'where to'
        dest = @board.input_to_coord(gets.chomp) #check valid
        raise "Invalid input, please select a valid cell" if player.find_piece_index(start[0], start[1]).nil?
        piece = player.pieces[player.find_piece_index(start[0], start[1])]
        raise "Invalid input, please ensure input is within bounds" if start.nil? || dest.nil?
        raise "Invalid move, not within the moveset" unless piece.valid_move?(dest)
        rescue StandardError => e
          puts e.to_s.red
          retry
      end
        @board.update_board(player, start, dest)
        player = switch_player(player.name)
    end
  end
end