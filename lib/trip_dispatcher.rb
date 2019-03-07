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
      assigned_driver = @drivers.detect { |driver| driver.status == :AVAILABLE }
      raise ArgumentError, "no available drivers" if assigned_driver == nil
      ids = @trips.map { |trip| trip.id }
      new_trip = Trip.new(id: ids.max + 1,
                          passenger: nil, passenger_id: passenger_id,
                          start_time: Time.now.to_s, end_time: nil, cost: nil, rating: nil, driver_id: assigned_driver.id, driver: assigned_driver)
      @trips.push(new_trip)
      assigned_driver.start_trip(new_trip)
      assigned_passenger = find_passenger(passenger_id)
      assigned_passenger.add_trip(new_trip)
      return new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.driver = driver
        driver.add_trip(trip)
        trip.connect(passenger)
      end

      return trips
    end
  end
end
