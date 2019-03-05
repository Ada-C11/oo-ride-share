require_relative "csv_record"

# Parent CsvRecord to Passenger class
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

    #will return the total amount of money
    # that passenger has spent on their trips
    def net_expenditures
      total_cost = 0
      @trips.each do |trip|
        total_cost += trip.cost
      end
      return total_cost
    end

    # will return the total amount of time
    # that passenger has spent on their trips
    def total_time_spent
      total_time = 0
      @trips.each do |trip|
        total_time += trip.duration.to_i
      end
      return total_time
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
