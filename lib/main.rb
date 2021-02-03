require_relative 'board'
require_relative 'game'
require_relative 'colors'
require 'io/console'
require 'yaml'

def instructions
  <<~HEREDOC

    Hello! Welcome to my Greatest Work in progress chess game!

    To play is relatively straightforward.
    The general rules of chess are enforced, with the exception of en passant and castling
    not being supported at the moment.

    To choose a piece to move and/or a location to move to just type its coordinates
    (e.x. 'd4') and then press enter

    Good luck, enjoy, and my github is parkercon if there is any problems!

    press any key to continue...
  HEREDOC
end

def save_game(game)
  begin
  files = Dir.glob('saved/*').map {|file| file[(file.index('/') + 1)...(file.index('.'))]}
  puts 'What you like the filename to be?'
  filename = gets.chomp 
  raise "#{filename} already exists would you like to overwrite (y/n)" if files.include?(filename)
  rescue StandardError => e
    puts e.to_s.red
    input = gets.chomp.downcase
    until input == 'y' || input == 'n'
      puts "Invalid input".red
      puts e.to_s.red
    end
    if input == 'y'
      dump = YAML.dump(game)
      File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file.write dump }
    else
      retry
    end
  end
  dump = YAML.dump(game)
  File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file.write dump }
  puts 'File saved!'
end

def load_game
  begin
  files = Dir.glob('saved/*').map {|file| file[(file.index('/') + 1)...(file.index('.'))]}
  puts "\nAvailable files: "
  puts files
  puts "\nPlease enter filename: "
  filename = gets.chomp
    raise "Invalid input, #{filename} does not exist" if !files.include?(filename)
    rescue StandardError => e
      puts e.to_s.red
      retry
  end
  game = File.open(File.join(Dir.pwd, "saved/#{filename}.yaml"), 'r')
  load_game = YAML.load(game)
  game.close
  load_game
end

def menu
  puts instructions
  STDIN.getch
  input = nil
  until input == '1' || input == '2' || input == '3' || input == '4'
    puts "\nHello, Welcome to my great chess game in progress!\nWhat would you like to do?\n"
    puts '(1) Player vs Player'
    puts '(2) Load a Game'
    puts '(3) Quit'
    input = gets.chomp
    case input
    when '1'
      g = Game.new
      g.begin
    when '2'
      g = load_game
    when '3'
      puts "Thanks for playing!\n"
      return 
    else 
      puts "Invalid Input, try again".red
    end
  end
  result = g.play_game
  save_game(g) if result == 'save'
  return if result == 'quit'
  puts "Thanks for playing!\n"
  menu 
end

menu