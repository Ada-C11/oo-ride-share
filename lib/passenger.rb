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
      return @trips.reduce(0) do |total_cost, trip|
               total_cost += trip.cost
             end
    end

    def total_time_spent
      return @trips.reduce(0) do |total_time_spent, trip|
               total_time_spent += ((trip.duration) / 60)
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
