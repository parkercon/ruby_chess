require './lib/board'

describe Board do
  describe '#letter_to_number' do
    subject(:board) { described_class.new('name1', 'name2') }
    context 'converts a letter coordinate to a number representing the column' do
      it 'takes a and returns 0' do
        input = 'a'
        solution = board.letter_to_number(input)
        expect(solution).to eq(0)
      end
      it 'takes f and returns 5' do
        input = 'f'
        solution = board.letter_to_number(input)
        expect(solution).to eq(5)
      end
      it 'takes z and returns 25' do
        input = 'z'
        solution = board.letter_to_number(input)
        expect(solution).to eq(25)
      end
      xit 'handles invalid input' do
        #might not be this functions responsibility
      end
    end

  describe '#valid_input?' do
    subject(:board) { described_class.new('name1', 'name2') }
    context 'when a user enters a3 (valid input)' do
      it 'returns true' do
        input = 'a3'
        solution = board.valid_input?(input)
        expect(solution).to be_truthy
      end
    end
    context 'when a user enters g6 (valid input)' do
      it 'returns true' do
        input = 'g6'
        solution = board.valid_input?(input)
        expect(solution).to be_truthy
      end
    end
    context 'when a user enters gg (invalid input)' do
      it 'returns false' do
        input = 'gg'
        solution = board.valid_input?(input)
        expect(solution).to be_falsy
      end
    end
    context 'when a user enters abcd (invalid input)' do
      it 'returns false' do
        input = 'abcd'
        solution = board.valid_input?(input)
        expect(solution).to be_falsy
      end
    end
    context 'when a user enters 123 (invalid input)' do
      it 'returns false' do
        input = '123'
        solution = board.valid_input?(input)
        expect(solution).to be_falsy
      end
    end
  end
  describe "#input_to_coord" do
    subject(:board) { described_class.new('name1', 'name2') }
    context 'when user enters b3' do
      it 'returns [3, 1]' do
        input = 'b3'
        solution = board.input_to_coord(input)
        expect(solution).to eq([3, 1])
      end
    end
    context 'when user enters h7' do
      it 'returns [7, 7]' do
        input = 'h7'
        solution = board.input_to_coord(input)
        expect(solution).to eq([7, 7])
      end
    end
  end

  end
end