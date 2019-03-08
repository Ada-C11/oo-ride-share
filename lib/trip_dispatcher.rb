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
      first_available_driver = ""
      @drivers.each do |driver|
        if driver.status == :AVAILABLE
          first_available_driver = driver
          break
        end
      end

      if first_available_driver == ""
        return "Sorry, no available drivers.  Try again later!"
      end

      new_trip = RideShare::Trip.new(
        id: @trips.count + 1,
        driver: first_available_driver,
        passenger_id: passenger_id,
        start_time: Time.now.to_s,
        end_time: nil,
        rating: nil,
        cost: nil,
      )

      passenger = find_passenger(passenger_id)
      passenger.add_trip(new_trip)

      driver = first_available_driver
      driver.assign_new_trip(new_trip)
      return new_trip
    end

    # Assigns first driver who's :AVAILABLE  <-- DONE
    # Uses current time for start time <-- DONE
    # End date, cost and rating = nil  <-- DONE

    # Create a new instance of Trip <-- DONE
    # Modify the selected driver using a new HELPER METHOD in Driver <-- HELPS DRIVER
    #   - Add new trip to collection of trips for that Driver  <--- DONE
    #   - Set the driver's status to :UNAVAILABLE <--- HELPS DRIVER
    # Add the Trip to the Passenger's list of Trips <--- DONE
    # Add the new trip to the collection of all Trips in TripDispatcher <--- HELPS TRIPDISPATCHER
    # Return the newly-created trip

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
