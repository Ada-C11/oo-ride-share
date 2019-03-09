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

    # def find_available_driver
      # @drivers.each do |available_driver|
      #   if available_driver.status == :AVAILABLE
      #     new_trip_driver = available_driver
      #     # new_trip_driver.status = :UNAVAILABLE
      #     return new_trip_driver
      #   end
      # end
      # return nil
    # end

    def request_trip(passenger_id)
      passenger = find_passenger(passenger_id)
      new_trip_driver = @drivers.find { |driver| 
        driver.status == :AVAILABLE 
      }
      
      if new_trip_driver == nil
        raise ArgumentError, "Driver's ride is currently in-progress"
      end

        new_trip = RideShare::Trip.new(
          id: @trips.length + 1,
          driver: new_trip_driver,
          passenger: passenger,
          passenger_id: find_passenger(passenger_id),
          start_time: Time.now.to_s,
          end_time: nil,
          cost: nil,
          rating: nil,
        )
        new_trip_driver.status = :UNAVAILABLE
        @trips << new_trip
        passenger = find_passenger(passenger_id)
        passenger.add_trip(new_trip)
        driver = new_trip_driver
        driver.add_trip(new_trip)
          
        return new_trip
    end

    # NEW
    # def request_trip(passenger_id)
    #   first_available_driver = @drivers.find do |driver|
    #     driver.status == :AVAILABLE
    #   end
    #   ids = @trips.map do |trip|
    #     trip.id
    #   end
    #   new_id = ids.max + 1
    #   new_trip = RideShare::Trip.new(
    #     id: new_id,
    #     passenger_id: passenger_id,
    #     driver_id: first_available_driver.id,
    #     start_time: Time.now.to_s,
    #     end_time: nil,
    #     cost: nil,
    #     rating: nil,
    #   )
    #   @trips << new_trip
    #   first_available_driver.change_status(new_trip)
      
    #   passenger = find_passenger(passenger_id)
    #   passenger.add_trip(new_trip)

    #   return new_trip
    # end

    def change_status(driver_id)
      found_driver = find_available_driver
      found_driver.status = :UNAVAILABLE
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
