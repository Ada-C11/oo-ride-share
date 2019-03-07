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

    # take into account incomplete trips
    def net_expenditures
      sum_cost = 0.00
      @trips.each do |trip|
        if !trip.cost.nil?
          sum_cost += trip.cost
        end
      end
      return sum_cost
    end

    def total_time_spent
      time_spent = 0
      @trips.each do |trip|
        if !trip.end_time.nil?
          time_spent += trip.trip_duration
        end
      end
      return time_spent
    end

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               phone_number: record[:phone_num],
             )
    end
  end
end
