require "csv"
require "time"
# TEST_DATA_DIRECTORY = "./specs/test_data"

require_relative "csv_record"
require_relative "passenger"
require_relative "trip"
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)

      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      return @drivers.find { |driver| driver.id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    def connect_trips
      @trips.each do |trip|
        # passenger_id = trip.passenger_id
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)

        @trips.each do |trip|
          driver = find_driver(trip.driver_id)
          trip.connect_driver(driver)
        end
      end

      return trips
    end
  end
end

# def build_test_dispatcher
#   return RideShare::TripDispatcher.new(
#            directory: TEST_DATA_DIRECTORY,
#          )
# end

# @dispatcher = build_test_dispatcher
# p @dispatcher.drivers
