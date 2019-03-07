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
      total = 0
      self.trips.each do |trip|
        unless trip.end_time == nil
          total += trip.cost
        end
      end
      return total.truncate(2)
    end

    def total_time_spent
      total = 0
      self.trips.each do |trip|
        unless trip.end_time == nil
          total += trip.trip_duration_seconds
        end
      end
      return total
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
