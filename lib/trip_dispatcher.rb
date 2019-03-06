require "csv"
require "time"
require "pry"

require_relative "passenger"
require_relative "trip"
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      connect_trips
      @drivers = Driver.load_all(directory: directory)
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
      until driver.status == :AVAILABLE
        @drivers.each do |driver|
          return Trip.new(
                   driver_id: driver_id,
                   id: id,
                   passenger: passenger_id,
                   start_time: Time.now,
                 )
        end
      end
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        #binding.pry
        driver = find_driver(trip.driver_id)
        trip.connect(passenger)
        trip.connect(driver)
      end

      return trips
    end
  end
end
