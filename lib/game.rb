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

  def begin
    puts "Hello, welcome give instruction later"
    puts "Player one, you will be white, what is your name?\n"
    name1 = gets.chomp
    puts "Player one, you will be black, what is your name?\n"
    name2 = gets.chomp
    @player_one = Player.new(name1, 'white')
    @player_two = Player.new(name2, 'black')
    @board = Board.new
    play_game
  end

  def play_game
    done = false
    player = player_one
    opponent = player_two
    until done == true do
      begin
        puts "#{player.name}, your turn!\n"
        @board.generate_board_visual
        puts @board.print_board(@player_one, @player_two)
        puts 'choose piece or type "save" to save the game'
        start = gets.chomp
        return 'save' if start == 'save'
        start = @board.input_to_coord(start)
        puts 'where to'
        dest = @board.input_to_coord(gets.chomp) 
        56.times {puts "\n"}
        raise "Invalid input, please try again" if start.nil?
        raise "Invalid input, please try again" if dest.nil?
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
      result = @board.update_board(player, opponent, start, dest)
        if !result.nil?
          opponent = player
          player = switch_player(player.name)
        end
        if result == 'checkmate'
          puts "Congratulations #{opponent.name}, you won!\n"
          puts "Thanks for playing!\n"
          done = true
          return 'checkmate'
        end
    end
  end
end