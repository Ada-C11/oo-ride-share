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
      available_drivers = @drivers.find_all { |driver| driver.status == :AVAILABLE }
      if available_drivers == []
        raise ArgumentError.new("Sorry, there are no available drivers near you.")
      end

      available_drivers.each do |driver|
        if driver.trips == []
          return driver
        end
      end
      return driver.trips.min_by { |trip| trip.end_time }.driver
    end

    def request_trip(passenger_id)
      new_ride = Trip.new(
        id: (@trips.length) + 1,
        driver: available_driver,
        passenger: find_passenger(passenger_id),
        start_time: Time.now.to_s,
        end_time: nil,
        rating: nil,
      )

      new_ride.driver.status = :UNAVAILABLE
      new_ride.driver.add_trip(new_ride)
      new_ride.passenger.add_trip(new_ride)

      @trips << new_ride

      return new_ride
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
