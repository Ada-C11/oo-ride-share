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
      passenger = find_passenger(passenger_id)
      avail_driver = drivers.find { |driver| driver.status == :AVAILABLE }
      #return nil != avail_driver
      start_time = Time.now
      end_time = nil
      cost = nil
      rating = nil
      current_trip = RideShare::Trip.new(
        driver_id: avail_driver.id,
        id: 6,
        passenger: passenger,
        start_time: start_time.to_s,
        end_time: nil,
        cost: nil,
        rating: nil,
      )
      passenger.add_trip(current_trip)
      avail_driver.add_trip(current_trip)
      @trips << current_trip
      avail_driver.status = :UNAVAILABLE
      return current_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        driver = find_driver(trip.driver_id)
        passenger = find_passenger(trip.passenger_id)
        trip.connect(passenger, driver)
      end
      return trips
    end
  end
end
