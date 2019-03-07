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

      #find a driver who is :AVAILABLE(loop through all drivers until we hit :AVAILABLE)
      #when we do, create a Trip instance with this driver, for the passenger provided based on their ID
      #mark current time as the start time - start_tim: Time.now
      #end_date, cost, rating are NIL bc trip has not finished

      # @drivers.each do |driver|
      #   if Driver.status == :AVAILABLE
      #   return Trip.new(
      #            driver_id: driver_id,
      #            id: id,
      #            passenger: passenger_id,
      #            start_time: Time.now,
      #          )
      # end

      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          return Trip.new(
                   id: 20,
                   driver_id: driver.id,
                   passenger_id: passenger_id,
                   start_time: Time.now.to_s,
                   end_time: nil,
                   cost: nil,
                   rating: nil,
                 )
        end
      end
      # until @drivers.status == :AVAILABLE
      # @drivers.each do |driver|
      #   return Trip.new(
      #            driver_id: @driver_id,
      #            id: @id,
      #            passenger: @passenger_id,
      #            start_time: Time.now,
      #          )
      # end
      # end
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
