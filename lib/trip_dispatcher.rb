require "csv"
require "time"

require_relative "passenger"
require_relative "trip"
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers
    attr_accessor :trips

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
          change_status(driver_new_trip)
          driver.add_trip(self)
        end
      end

      if driver_new_trip == 0
        return nil
      end

      trip_id = trips.count + 1
      trip = RideShare::Trip.new(
        passenger_id: passenger_id,
        id: trip_id,
        start_time: Time.now.to_s,
        driver_id: driver_new_trip,
      )
      self.find_passenger(passenger_id).add_trip(trip)
      @trips << trip
      return trip
    end

    def change_status(driver_id)
      driv = find_driver(driver_id)
      driv.status = :UNAVAILABLE
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect_passenger(passenger)
        trip.connect_driver(driver)
      end

      return trips
    end
  end
end
