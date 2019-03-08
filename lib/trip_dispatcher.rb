require "csv"
require "time"

require_relative "passenger"
require_relative "trip"
require_relative "driver"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips
    attr_accessor :find_driver

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

      # @drivers.each do |driver|
      #   all_statuses << driver.status

      #   if all_statuses.all? { |status| status == :UNAVAILABLE }
      #     raise ArgumentError, "There are no available drivers."
      #   end
      # end

      
      current_driver = drivers.find { |driver| driver.status == :AVAILABLE}
      if current_driver == nil
        raise ArgumentError, "There are no available drivers."
      end

        # all_statuses << driver.status

        # if all_statuses.all? { |status| status == :UNAVAILABLE }
        #   raise ArgumentError, "There are no available drivers."
        # end

        # if driver.status == :AVAILABLE
          passenger = find_passenger(passenger_id)

          new_trip = RideShare::Trip.new(
            id: @trips.length + 1,
            driver_id: current_driver.id,
            passenger_id: find_passenger(passenger_id),
            start_time: Time.now.to_s,
            end_time: nil,
            cost: nil,
            rating: nil,
          )

          passenger.add_trip(new_trip)

          current_driver.change_status(new_trip)

          @trips << new_trip

          return new_trip
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
