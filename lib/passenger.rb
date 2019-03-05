require_relative 'csv_record'

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

    # Add an instance method, net_expenditures, to Passenger that will return the total amount of money that passenger has spent on their trips
    # take passenger ID and all IDs listed in trip with that passenger ID, need to tally up the total spent
    def net_expenditures
      total_trip = 0
      @trips.each do |trip|
        # if trip.nil?
        #   next
        # end
        total_trip += trip.cost
      end
      return total_trip
    end
    
    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end

  end
end
