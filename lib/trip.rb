require "csv"

require_relative "csv_record"
# require_relative "trip_dispatcher"

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver_id, :driver

    def initialize(id:,
                   passenger: nil,
                   passenger_id: nil,
                   start_time:,
                   end_time:,
                   cost: nil,
                   rating:,
                   driver_id: nil,
                   driver: nil)
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, "Passenger or passenger_id is required"
      end

      @start_time = Time.parse(start_time)
      @end_time = Time.parse(end_time)

      unless @start_time < @end_time
        raise ArgumentError, "Ride must end after it begins, not before"
      end

      @cost = cost
      @rating = rating

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if driver_id == nil && driver == nil
        raise ArgumentError, "Driver ID or Driver must be provided"
      elsif driver_id == nil
        @driver = driver
        @driver_id = driver.id # find the driver id based on the driver
      elsif driver == nil
        @driver_id = driver_id
        @driver = find_driver(driver_id) # find the driver based on the driver id
      else
        @driver_id = driver_id
        @driver = driver
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def trip_duration
      end_time.to_i - start_time.to_i
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
