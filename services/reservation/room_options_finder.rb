# frozen_string_literal: true

module Reservation
  class RoomOptionsFinder
    def initialize(number_of_guests:, room_types:)
      @number_of_guests = number_of_guests
      @room_types = room_types || []
      @room_options = []
    end

    def perform
      return EMPTY_OPTIONS if room_types.empty?
      return EMPTY_OPTIONS if number_of_guests <= 0

      build_room_options(0, [])
      prevent_duplicated_options
      build_output
    end

    private

    def build_output
      output = []

      room_options.each do |rooms|
        output << {
          label: rooms.map(&:name).uniq.join(' '),
          total_costs: rooms.map(&:price).sum,
          rooms_summarize: build_rooms_summarize(rooms),
          rooms:
        }
      end

      output
    end

    def prevent_duplicated_options
      room_options.map do |rooms|
        rooms.sort_by!(&:capacity)
      end

      @room_options = room_options.uniq
    end

    def build_rooms_summarize(rooms)
      rooms.each_with_object(Hash.new(0)) do |room, h|
        h[room.name] += 1
      end
    end

    def build_room_options(filled_guests, filled_rooms)
      return if filled_guests > number_of_guests

      if filled_guests == number_of_guests
        room_options << filled_rooms
        return
      end

      room_types.each do |room|
        next if room.available.zero?

        room.available -= 1
        build_room_options(filled_guests + room.capacity, filled_rooms + [room])
        room.available += 1
      end
    end

    attr_reader :number_of_guests, :room_types, :room_options

    EMPTY_OPTIONS = [
      {
        label: nil,
        total_costs: 0,
        rooms_details: []
      }
    ].freeze
  end
end
