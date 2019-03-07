require "csv"

require_relative "csv_record"
require "pry"
require "time"

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :driver, :driver_id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating

    def initialize(id:, driver: nil, driver_id: nil,
                   passenger: nil, passenger_id: nil,
                   start_time:, end_time: nil, cost: nil, rating: nil)
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, "Passenger or passenger_id is required"
      end

      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      end

      @start_time = Time.parse(start_time)
      @end_time = end_time
      if @end_time != nil
        @end_time = Time.parse(end_time)
      end
      if @end_time != nil && @start_time > @end_time
        raise ArgumentError, "End time must come after start time."
      end
      @cost = cost
      @rating = rating

      unless rating == nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end

    def trip_duration_seconds
      if end_time == nil
        raise ArgumentError, "This trip is still in progress. Duration can't be calculated."
      else
        duration = (end_time - start_time).to_i
      end
      return duration
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect_passenger(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def connect_driver(driver)
      @driver = driver
      driver.add_trip(self)
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               driver_id: record[:driver_id],
               passenger_id: record[:passenger_id],
               start_time: record[:start_time],
               end_time: record[:end_time],
               cost: record[:cost],
               rating: record[:rating],
             )
    end
  end
end
