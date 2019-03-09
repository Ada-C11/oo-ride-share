require "csv"
require "time"

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
      passenger = find_passenger(passenger_id)

      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          new_trip = RideShare::Trip.new(
            driver_id: driver.id,
            id: @trips.length + 1,
            passenger_id: passenger_id,
            start_time: Time.now.to_s,
            end_time: nil,
            cost: nil,
            rating: nil,
          )
          passenger.add_trip(new_trip)
          @trips << new_trip
          return new_trip
        end
      end

      # choose driver with status :AVAILABLE
      # use current time
      # end time, cost, and rating == nil; don't calculate trip in any other instances
      # when nil, ignore (skip)
      # add to the driver's log
      # set driver to :UNAVAILABLE
      # add to passenger's log
      # add the trip to collection of all Trips in TripDispatcher
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        trip.connect_passenger(passenger)
        driver = find_driver(trip.driver_id)
        trip.connect_driver(driver)
      end
      return trips
    end
  end
end
