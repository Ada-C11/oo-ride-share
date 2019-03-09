require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers
    attr_accessor :trips

    def initialize(directory: './support')
      @drivers = Driver.load_all(directory: directory)
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      # connect_trips
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

    def find_available_driver
      @drivers.each do |available_driver|
        if available_driver.status == :AVAILABLE
          new_trip_driver = available_driver
          new_trip_driver.status = :UNAVAILABLE
          return new_trip_driver
        end
      end
      return nil
    end

    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id)
      driver = find_available_driver

        new_trip = RideShare::Trip.new(
          id: @trips.length + 1,
          driver_id: driver.id,
          passenger: passenger,
          passenger_id: passenger.id,
          start_time: Time.now.to_s,
          end_time: nil,
          cost: nil,
          rating: nil,
        )
        
        @trips << new_trip
        new_trip.driver.add_trip(new_trip)
        new_trip.passenger.add_trip(new_trip)
          
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
