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
      @passengers = Passenger.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
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
    
    def inspect
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      available_driver = @drivers.select {|driver| driver.status == :AVAILABLE}.first

      if available_driver == []
        raise ArgumentError, "No drivers are available."
      end
      
      passenger = find_passenger(passenger_id)
      driver_id = available_driver.id
      time = Time.now.to_s
      
      in_progress_trip = Trip.new(
        id: 7,
        passenger_id: passenger_id,
        start_time: time,
        end_time: nil, 
        cost: nil, 
        rating: nil,
        driver: available_driver, 
        driver_id: driver_id
      )
        
      in_progress_trip.connect(passenger, available_driver)
      available_driver.accept_new_trip(in_progress_trip)

      return in_progress_trip
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
