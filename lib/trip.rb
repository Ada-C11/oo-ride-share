require "csv"
require "time"

require_relative "csv_record"
#removed all the require relatives

module RideShare
  class Trip < CsvRecord # added driver_id and driver to reader
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :duration, :driver_id, :driver

    def initialize(id:,
                   passenger: nil, passenger_id: nil,
                   start_time:, end_time:, cost: nil, rating:, driver: nil, driver_id: nil)
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      elsif passenger_id == 0
        raise ArgumentError, "Passenger or passenger_id is invalid"
      else
        raise ArgumentError, "Passenger or passenger_id is required"
      end

      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      elsif driver_id == 0
        raise ArgumentError, "Driver or driver_id is invalid"
      else
        raise ArgumentError, "Driver or driver_id is required"
      end

      @start_time = Time.parse(start_time)
      @end_time = Time.parse(end_time)
      @cost = cost
      @rating = rating
      @duration = duration_secs(start_time, end_time)

      # Add a check in Trip#initialize that raises an ArgumentError if the end
      # time is before the start time, and a corresponding test
      if start_time > end_time
        raise ArgumentError.new("Invalid")
      end

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    # updated to take 2 arguments since we call it in trip dispatcher based on that.
    # Added ability to also connect driver
    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
      @driver = driver
      driver.add_trip(self)
    end

    # Actually don tthink this is important anymore. Consolidated into connect method.
    # # changed method name here from connect to connect driver. Ruby was confusing them.
    # def connect_driver(driver)
    #   @driver = driver_id
    #   driver.add_trip(self)
    # end

    def duration_secs(start_time, end_time)
      duration = (@end_time) - (@start_time)
      return duration.to_i.to_s
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: record[:start_time],
               end_time: record[:end_time],
               cost: record[:cost],
               rating: record[:rating],
               driver_id: record[:driver_id],
             )
    end
  end
end
