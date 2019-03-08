require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number
    attr_accessor :trips
    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      cost_sum = 0
      @trips.each do |trip|
        cost_sum += trip.cost unless trip.cost.nil?
      end
      cost_sum
    end

    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        total_time += trip.calculate_duration unless trip.end_time.nil?
      end
      total_time
    end

    private

    def self.from_csv(record)
      new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
