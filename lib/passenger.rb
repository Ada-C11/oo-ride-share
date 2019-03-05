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
      total_cost = 0
      trips.each do |trip|
        total_cost += trip.cost
      end
      return total_cost
    end

    def total_time_spent
      time_total = 0
      trips.each do |trip|
        time_total += trip.duration_in_seconds
      end
      return time_total.to_i.to_s
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
