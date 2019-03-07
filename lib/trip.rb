require "csv"
require "time"
require "date"
require_relative "csv_record"

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :driver_id, :driver, :start_time, :end_time, :cost, :rating

    def initialize(id:,
                   passenger: nil, passenger_id: nil, driver_id: nil, driver: nil,
                   start_time:, end_time:, cost: nil, rating:)
      super(id)

      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError, "Driver or driver_id is required"
      end

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, "Passenger or passenger_id is required"
      end

      start_time = Time.parse(start_time)

      unless end_time.nil?
        end_time = Time.parse(end_time)

        if start_time.to_i > end_time.to_i
          raise ArgumentError.new("End time cannot be before start time")
        end
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating

      if !@rating.nil? && (@rating > 5 || @rating < 1)
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

    def connect(passenger, driver)
      @passenger = passenger
      @driver = driver
      passenger.add_trip(self)
      driver.add_trip(self)
    end

    def trip_duration
      # test when end time is nil
      if @end_time.nil?
        raise ArgumentError.new("End time is nil")
      end
      return (@end_time - @start_time).to_i
    end

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: record[:start_time],
               end_time: record[:end_time],
               driver_id: record[:driver_id],
               cost: record[:cost],
               rating: record[:rating],
             )
    end
  end
end
