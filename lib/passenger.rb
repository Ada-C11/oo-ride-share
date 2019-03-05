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
      total = 0
      @trips each do |trip|
        net_cost = trip.cost 
      end
      return net_cost
    end

    # will return the total amount of time
    # that passenger has spent on their trips
    def total_time_spent
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
