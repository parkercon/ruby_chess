require './lib/pawn'

describe Pawn do
  describe '#get_valid_moves' do
    context 'when a white pawn is just beginning' do
      subject(:pawn) { described_class.new(6, 0, 'white') }
      it 'returns [5, 0], [4,0]' do
        # pawn.moved = false
        expected = [[5, 0], [4,0]]
        solution = pawn.get_valid_moves
        expect(solution).to eq(expected)
      end
    end
    context 'when a black pawn has already moved' do
      subject(:pawn) { described_class.new(2, 5, 'black') }
      it 'returns [3, 5]' do
        pawn.moved = true
        expected = [[3, 5]]
        solution = pawn.get_valid_moves
        expect(solution).to eq(expected)
      end
    end
  end
end