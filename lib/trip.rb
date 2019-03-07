require "csv"

require_relative "csv_record"

require "time"

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    def initialize(id:, driver_id:,
                   passenger: nil, passenger_id: nil,
                   start_time:, end_time:, cost: nil, rating:)
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, "Passenger or passenger_id is required"
      end

      @driver_id = driver_id
      @start_time = Time.parse(start_time)
      if end_time != nil
        @end_time = Time.parse(end_time)
      end
      @cost = cost
      @rating = rating

      if @end_time != nil && (@start_time > @end_time)
        raise ArgumentError, "Start time cannot preceed end time."
      end
      if @rating != nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end

    def trip_duration
      if end_time == nil
        raise ArgumentError.new("Trip is still in progress.")
      else
        duration = end_time - start_time
        return duration.to_i
      end
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect(passenger, driver)
      @passenger = passenger
      passenger.add_trip(self)
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
