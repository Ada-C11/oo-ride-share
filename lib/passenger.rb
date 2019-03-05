require_relative "csv_record"
# require_relative "trip"
# require_relative "trip_dispatcher"

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
      # total_cost = @trips.inject { |sum, trip| sum + trip.cost }
      # puts "total_cost"
      sum = 0
      total_cost = @trips.each do |trip|
        sum += trip.cost
      end
      total_cost = sum

      return total_cost
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

# passenger = RideShare::Passenger.new(
#   id: 9,
#   name: "Merl Glover III",
#   phone_number: "1-602-620-2330 x3723",
#   trips: [],
# )
# trip = RideShare::Trip.new(
#   id: 8,
#   passenger: @passenger,
#   start_time: "2016-08-08",
#   end_time: "2016-08-09",
#   cost: 10,
#   rating: 5,
# )

# passenger.add_trip(trip)
# net_expenditures = passenger.net_expenditures
