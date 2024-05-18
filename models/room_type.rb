# frozen_string_literal: true

class RoomType
  attr_accessor :available
  attr_reader :name, :capacity, :price

  def initialize(name:, capacity:, available:, price:)
    @name = name
    @capacity = capacity
    @available = available
    @price = price
  end
end
