require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      new_trip_driver = nil
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          new_trip_driver = driver
          break
        end
      end
      if new_trip_driver == nil 
        return nil
      end

      # new_trip_driver = driver
      time = Time.now.to_s
      time_now = Time.parse(time)
      new_trip = RideShare::Trip.new(
        id: @trips.last.id + 1,
        passenger_id: passenger_id,
        driver: new_trip_driver,
        start_time: time_now.to_s,
        end_time: nil,
        cost: nil,
        rating: nil
      )
      new_trip_driver.add_trip(new_trip)
      new_trip_passenger = find_passenger(passenger_id)
      new_trip_passenger.add_trip(new_trip)
      new_trip_driver.status = "UNAVAILABLE"
      @trips << new_trip
      connect_trips
      new_trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger)
        trip.connect(driver)
      end

      trips
    end
  end
end
