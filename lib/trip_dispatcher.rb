require "csv"
require "time"

require_relative "passenger"
require_relative "trip"
require_relative "driver"
require_relative "csv_record.rb"

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

    # def find_next_available_driver
    #   new_driver = @drivers.find { |driver| driver.status == :AVAILABLE }
    #   return new_driver
    # end

    # Option for adding argument error for no driver
    def find_next_available_driver
      new_driver = @drivers.find { |driver| driver.status == :AVAILABLE }
      if new_driver == nil
        raise ArgumentError, "There is no available driver"
      else
        return new_driver
      end
    end

    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id).id
      driver = find_next_available_driver
      id = @trips.length + 1
      new_trip = RideShare::Trip.new(id: id, passenger_id: passenger, driver: driver, start_time: Time.now.to_s, end_time: nil, rating: nil)
      @trips << new_trip
      #new_trip.passenger.add_trip(new_trip) # this does not work yet
      new_trip.driver.add_trip(new_trip) # added this to the code & corresponding test passes
      @status = :UNAVAILABLE # this isn't working, what is @status?
      # new_trip.driver.status = :UNAVAILABLE

      return new_trip
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
