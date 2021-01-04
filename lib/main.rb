require_relative 'board'

b = Board.new('bop', 'parker')
puts b.print_board  
b.update_board([1, 2])