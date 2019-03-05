require_relative "csv_record"

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
      @total_spent = 0
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      array = []
      trips.each do |trip|
        array << trip.cost
      end
      total = array.reduce(:+)
      return total
    end

    def total_time_spent
      array = []
      trips.each do |trip|
        array << trip.trip_duration
      end
      total = array.reduce(:+)
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
