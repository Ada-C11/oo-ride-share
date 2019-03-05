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

    def total_time_spent
      all_trip_durations = 0

      self.trips.each do |trip|
        trip_duration = trip.duration
        all_trip_durations += trip_duration
      end

      return all_trip_durations
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
