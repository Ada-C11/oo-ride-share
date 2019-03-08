require "csv"
require "time"

require_relative "passenger"
require_relative "trip"
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips, :hi

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      passenger = @passengers.find { |passenger| passenger.id == id }
      raise ArgumentError, "Passenger not found" unless passenger
      return passenger
    end

    def find_driver(id)
      driver = @drivers.find { |driver| driver.id == id }
      raise ArgumentError, "Passenger not found" unless driver
      return driver
    end

    def find_available_driver
      available_driver = @drivers.find { |driver| driver.status == :AVAILABLE }
      raise ArgumentError, "No available drivers" unless available_driver
      return available_driver
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      @available_driver = find_available_driver
      trip = RideShare::Trip.new(
        id: @trips.count + 1,
        passenger_id: passenger_id,
        start_time: Time.now.to_s, ###
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: @available_driver,
      )
      return trip
    end

    def trip_in_progress(passenger_id)
      trip = request_trip(passenger_id)
      # Driver needs to accept trip.
      @available_driver.accept_trip(trip)
      # Add the Trip to the Passenger's list of Trips
      #WARNING: possible the passenger id has no associated passenger object!
      find_passenger(passenger_id).add_trip(trip)
      # Add the new trip to the collection of all Trips in TripDispatcher
      @trips << trip
      connect_trips
      return trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        # finds passenger as instance
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger: passenger)
        trip.connect(driver: driver)
      end
      return trips
    end
  end
end
