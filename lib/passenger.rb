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
      total_amount = 0.0
      @trips.each do |trip|
        total_amount += trip.cost
      end
      return total_amount
    end

    def total_time_spent
      all_trip_durations = @trips.map { |trip| trip.duration }
      # duration method returns trip_duration as an integer in seconds
      total_time_on_trips = all_trip_durations.sum
      return total_time_on_trips
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
