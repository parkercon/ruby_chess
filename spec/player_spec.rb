require './lib/player'

describe Player do
  describe '#find_piece_index' do
    context 'when player wants to find knight at [7, 1] index' do
      subject(:player) { described_class.new('name', 'white') }
      it 'returns 9' do
        row = 7
        col = 1
        solution = player.find_piece_index(row, col)
        expect(solution).to eq(9)
      end
    end
  end
end