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

    def request_trip(passenger_id)
      new_trip = RideShare::Trip.new(
        id: generate_trip_id,
        passenger_id: passenger_id,
        start_time: Time.now.to_s,
        driver_id: find_available,
      )
      passenger = find_passenger(passenger_id)
      driver = find_driver(find_available)

      new_trip.connect(passenger, driver)
      driver.change_status
      return new_trip
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    def find_available
      @drivers.each do |driver|
        return driver.id if driver.status == :AVAILABLE
      end
      raise ArgumentError, "There are no available drivers."
    end

    def generate_trip_id
      trip_id_array = @trips.map { |record| record.id }
      generate_id = trip_id_array.max + 1
      return generate_id
    end

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
