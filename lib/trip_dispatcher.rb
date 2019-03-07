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
      driver_id = @drivers.find do |driver|
        driver.status == :AVAILABLE
      end
      ids = @trips.map do |trip|
        trip.id
      end
      new_id = ids.max + 1
      trips << Trip.new(
        id: new_id,
        passenger_id: passenger_id,
        start_time: Time.now.to_s,
        end_time: nil,
        driver_id: driver_id.id,
        cost: nil,
        rating: nil,
      )

      # call helper method
      @driver.change_status(trip)

      # add trip to passenger list
      passenger = find_passenger(passenger_id)
      passenger.add_trip(trip)

      return trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end

      return trips
    end
  end
end
