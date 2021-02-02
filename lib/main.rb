require_relative 'board'
require_relative 'game'
require_relative 'colors'
require 'yaml'

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
      puts "Invalid input"
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
      puts "Invalid Input, try again"
    end
  end
  result = g.play_game
  save_game(g) if result == 'save'
  puts "Thanks for playing!\n"
  menu 
end

menu