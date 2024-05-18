# frozen_string_literal: true

module Reservation
  class CheapestOptionFinder
    def initialize(room_options:)
      @room_options = room_options || []
    end

    def perform
      return NO_OPTION if room_options.empty?

      room_options.min_by { |option| option[:total_costs] }
    end

    private

    attr_reader :room_options

    NO_OPTION = {
      label: 'No option',
      total_costs: 0
    }.freeze
  end
end
