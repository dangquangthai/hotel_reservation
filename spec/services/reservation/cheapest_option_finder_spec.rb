# frozen_string_literal: true

require_relative '../../../services/reservation/cheapest_option_finder'

RSpec.describe Reservation::CheapestOptionFinder do
  subject { described_class.new(room_options:) }

  let(:no_option) { { label: 'No option', total_costs: 0 } }
  let(:cheapest_option) { { label: 'cheapest', total_costs: 1 } }
  let(:expensive_option) { { label: 'expensive', total_costs: 1.01 } }

  describe '#perform' do
    context 'when room_options is present' do
      let(:room_options) do
        [
          expensive_option,
          cheapest_option
        ]
      end

      it 'return cheapest option' do
        expect(subject.perform).to eq(cheapest_option)
      end
    end

    context 'when room_options is empty' do
      let(:room_options) { [] }

      it 'return no option' do
        expect(subject.perform).to eq(no_option)
      end
    end

    context 'when room_options is nil' do
      let(:room_options) { nil }

      it 'return no option' do
        expect(subject.perform).to eq(no_option)
      end
    end
  end
end
