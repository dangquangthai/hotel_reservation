# frozen_string_literal: true

require_relative 'models/room_type'
require_relative 'services/reservation/room_options_finder'
require_relative 'services/reservation/cheapest_option_finder'

room_types = [
  RoomType.new(name: 'Single', capacity: 1, available: 2, price: 30),
  RoomType.new(name: 'Double', capacity: 2, available: 3, price: 50),
  RoomType.new(name: 'Family', capacity: 4, available: 1, price: 85)
]

inputs = [2, 3, 6]

inputs.each do |number_of_guests|
  room_options = Reservation::RoomOptionsFinder.new(number_of_guests: number_of_guests, room_types: room_types).perform
  cheapest_option = Reservation::CheapestOptionFinder.new(room_options:).perform
  # best_option = Reservation::BestOptionFinder.new(room_options: room_options).perform
  # expensive_option = Reservation::ExpensiveOptionFinder.new(room_options: room_options).perform

  puts "#{cheapest_option[:label]} - $#{cheapest_option[:total_costs]}"
end
