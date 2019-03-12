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
      id = trips.length + 1

      find_passenger(passenger_id) ? (passenger = find_passenger(passenger_id)) : (return nil)
      intelligent_dispatch ? (assigned_driver = intelligent_dispatch) : (return nil)

      start_time = Time.now.to_s
      end_time = nil

      cost = nil
      rating = nil

      new_trip = RideShare::Trip.new(id: id,
                                     passenger: passenger,
                                     driver: assigned_driver,
                                     start_time: start_time,
                                     end_time: end_time,
                                     cost: cost,
                                     rating: rating)

      trips << new_trip
      assigned_driver.assign_trip(new_trip)
      passenger.add_trip(new_trip)
      return new_trip
    end

    def intelligent_dispatch
      available_drivers = drivers.select { |driver| driver.status == :AVAILABLE }
      assigned_driver = available_drivers.find { |driver| driver.trips == [] }
      if assigned_driver
        return assigned_driver
      else
        available_drivers.select! { |driver| driver.trips.last.end_time }
        assigned_driver = available_drivers.min_by { |driver| driver.trips.last.end_time }
        return assigned_driver
      end
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
