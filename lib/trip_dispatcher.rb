require "csv"
require "time"
TEST_DATA_DIRECTORY = "./specs/test_data"

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
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      passenger_id = passenger_id
      first_available_driver = @drivers.find { |driver| driver.status == :AVAILABLE }
      first_available_driver_id = first_available_driver.id
      current_time = Time.now.to_s
      puts Time.parse(current_time)
      end_time = nil
      cost = nil
      rating = nil
      trip_id = rand(100..999)
      trip_data = {id: trip_id,
                   passenger_id: passenger_id,
                   passenger: find_passenger(passenger_id),
                   start_time: current_time,
                   end_time: end_time,
                   cost: cost,
                   rating: rating,
                   driver: first_available_driver,
                   driver_id: first_available_driver_id}
      return Trip.new(trip_data)
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger)
      end

      @trips.each do |trip|
        driver = find_driver(trip.driver_id)
        trip.connect_driver(driver)
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

# @dispatcher = build_test_dispatcher\
# drivers = @dispatcher.drivers
