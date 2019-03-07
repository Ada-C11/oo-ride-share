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
      #added
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    #added
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
      driver_new_trip = 0
      drivers.find do |driver|
        if driver.status == :AVAILABLE
          driver_new_trip = driver.id
        end
      end
      trip_id = trips.count + 1
      trip = RideShare::Trip.new(
        passenger_id: passenger_id,
        id: trip_id,
        start_time: Time.now.to_s,
        driver_id: driver_new_trip,
      )
      return trip
      driver.find(driver_new_trip).status = :UNAVAILABLE
      # Add the new trip to the collection of trips for that Driver
      driver(driver_new_trip).add_trip(self)
      # Add the Trip to the Passenger's list of Trips
      passenger(passenger_id).add_trip(self)
      # Add the new trip to the collection of all Trips in TripDispatcher
      # I believe this happens with driver.add_trip and passenger.add_trip
      # @trips << trip # I don't think we need to do this
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        #added
        driver = find_driver(trip.driver_id)
        trip.connect_passenger(passenger)
        #added
        trip.connect_driver(driver)
      end

      return trips
    end
  end
end
