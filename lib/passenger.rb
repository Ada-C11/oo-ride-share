require_relative "csv_record"

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
      if @trips.length == 0
        raise ArgumentError, "This passenger doesn't have any trips"
      end
      total_cost = 0
      @trips.each do |trip|
        if trip.cost == nil
          next
        else
          total_cost += trip.cost
        end
      end
      return total_cost
    end

    def total_time_spent
      if @trips.length == 0
        raise ArgumentError, "This passenger doesn't have any trips"
      end
      return @trips.reduce(0) do |total_time, trip|
               total_time += trip.trip_duration
             end
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               phone_number: record[:phone_num],
             )
    end
  end
end
