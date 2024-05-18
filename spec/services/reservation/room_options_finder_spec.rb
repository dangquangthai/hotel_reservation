# frozen_string_literal: true

require_relative '../../../services/reservation/room_options_finder'
require_relative '../../../models/room_type'

RSpec.describe Reservation::RoomOptionsFinder do
  let(:no_option) do
    [
      {
        label: nil,
        total_costs: 0,
        rooms_details: []
      }
    ]
  end
  let(:single_room) { RoomType.new(name: 'Single', capacity: 1, available: single_available, price: 30) }
  let(:double_room) { RoomType.new(name: 'Double', capacity: 2, available: double_available, price: 50) }
  let(:family_room) { RoomType.new(name: 'Family', capacity: 4, available: family_available, price: 85) }
  let(:single_available) { 2 }
  let(:double_available) { 3 }
  let(:family_available) { 1 }
  let(:number_of_guests) { 2 }
  subject { described_class.new(number_of_guests:, room_types:) }

  let(:room_types) { [single_room, double_room, family_room] }

  describe '#perform' do
    context 'invalid inputs' do
      context 'when number_of_guests less than or equals zero' do
        let(:number_of_guests) { 0 }

        it 'return no option' do
          expect(subject.perform).to eq(no_option)
        end
      end

      context 'whem room_types is empty' do
        let(:room_types) { nil }

        it 'return no option' do
          expect(subject.perform).to eq(no_option)
        end
      end
    end

    context 'valid inputs' do
      context 'for 2 guests' do
        context 'when double room is available' do
          it 'return 2 options' do
            expect(subject.perform).to eq(
              [
                {
                  label: 'Single',
                  total_costs: 60,
                  rooms_summarize: { 'Single' => 2 },
                  rooms: [single_room, single_room]
                },
                {
                  label: 'Double',
                  total_costs: 50,
                  rooms_summarize: { 'Double' => 1 },
                  rooms: [double_room]
                }
              ]
            )
          end
        end

        context 'when double room is unavailable' do
          let(:double_available) { 0 }

          it 'return 1 option' do
            expect(subject.perform).to eq(
              [
                {
                  label: 'Single',
                  total_costs: 60,
                  rooms_summarize: { 'Single' => 2 },
                  rooms: [single_room, single_room]
                }
              ]
            )
          end
        end
      end

      context 'for 3 guests' do
        let(:number_of_guests) { 3 }

        it 'return 1 option' do
          expect(subject.perform).to eq(
            [
              {
                label: 'Single Double',
                total_costs: 80,
                rooms_summarize: { 'Single' => 1, 'Double' => 1 },
                rooms: [single_room, double_room]
              }
            ]
          )
        end
      end

      context 'for 4 guests' do
        let(:number_of_guests) { 4 }

        it 'return 3 options' do
          expect(subject.perform).to eq(
            [
              {
                label: 'Single Double',
                total_costs: 110,
                rooms_summarize: { 'Single' => 2, 'Double' => 1 },
                rooms: [single_room, single_room, double_room]
              },
              {
                label: 'Double',
                total_costs: 100,
                rooms_summarize: { 'Double' => 2 },
                rooms: [double_room, double_room]
              },
              {
                label: 'Family',
                total_costs: 85,
                rooms_summarize: { 'Family' => 1 },
                rooms: [family_room]
              }
            ]
          )
        end
      end

      context 'for 5 guests' do
        let(:number_of_guests) { 5 }

        it 'return 2 options' do
          expect(subject.perform).to eq(
            [
              {
                label: 'Single Double',
                total_costs: 130,
                rooms_summarize: { 'Single' => 1, 'Double' => 2 },
                rooms: [single_room, double_room, double_room]
              },
              {
                label: 'Single Family',
                total_costs: 115,
                rooms_summarize: { 'Single' => 1, 'Family' => 1 },
                rooms: [single_room, family_room]
              }
            ]
          )
        end
      end

      context 'for 6 guests' do
        let(:number_of_guests) { 6 }

        it 'return 2 options' do
          expect(subject.perform).to eq(
            [
              {
                label: 'Single Double',
                total_costs: 160,
                rooms_summarize: { 'Single' => 2, 'Double' => 2 },
                rooms: [single_room, single_room, double_room, double_room]
              },
              {
                label: 'Single Family',
                total_costs: 145,
                rooms_summarize: { 'Single' => 2, 'Family' => 1 },
                rooms: [single_room, single_room, family_room]
              },
              {
                label: 'Double',
                total_costs: 150,
                rooms_summarize: { 'Double' => 3 },
                rooms: [double_room, double_room, double_room]
              },
              {
                label: 'Double Family',
                total_costs: 135,
                rooms_summarize: { 'Double' => 1, 'Family' => 1 },
                rooms: [double_room, family_room]
              }
            ]
          )
        end
      end

      context 'for 7 guests and double_room is unavailable' do
        let(:number_of_guests) { 7 }
        let(:double_available) { 0 }

        it 'return 2 options' do
          expect(subject.perform).to be_empty
        end
      end
    end
  end
end
