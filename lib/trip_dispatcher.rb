require "csv"
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

    def available_driver
      if @drivers.find_all { |driver| driver.status == :AVAILABLE } == []
        raise ArgumentError.new("Sorry, there are no available drivers near you.")
      else
        available_drivers = @drivers.find_all { |driver| driver.status == :AVAILABLE }
      end

      available_drivers.each do |driver|
        if driver.trips == []
          return driver
        end
      end

      available_drivers = available_drivers.sort_by { |driver| driver.trips.last.end_time }

      return available_drivers.first
    end

    def request_trip(passenger_id)
      # The passenger ID will be supplied (this is the person requesting a trip)
      @drivers.each do |driver|
        if driver.id == passenger_id && driver.status == :AVAILABLE
          driver.status = :UNAVAILABLE
        end
      end

      driver = self.available_driver
      passenger = self.find_passenger(passenger_id)

      requested_trip = {
        id: (@trips.length) + 1,
        driver: driver,
        passenger: passenger,
        start_time: Time.now,
      # end_time: nil,
      # # rating: nil,
      }

      in_progress_ride = Trip.new(requested_trip)

      driver.status = :UNAVAILABLE
      driver.add_trip(in_progress_ride)
      passenger.add_trip(in_progress_ride)

      @trips << in_progress_ride

      @drivers.each do |driver|
        if driver.id == passenger_id
          driver.status = :AVAILABLE
        end
      end

      return in_progress_ride
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
