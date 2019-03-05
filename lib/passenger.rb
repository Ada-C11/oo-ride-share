require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

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
      net_expenditures = trips.reduce(0) {|total, trip| total += trip.cost}
      return net_expenditures
    end

    def total_time_spent
      total_time = trips.reduce(0) {|total, trip| total += trip.calculate_duration}
      return total_time
    end
    
    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
