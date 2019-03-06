require "csv"
require "awesome_print"
require "time"
require_relative "csv_record"
require_relative "../specs/spec_helper"

module RideShare
  class Trip < CsvRecord
<<<<<<< HEAD
    attr_reader  :passenger, :passenger_id, :start_time, :end_time, :cost, :rating
=======
    attr_reader :passenger, :passenger_id, :start_time, :end_time, :cost, :rating
>>>>>>> 2b88fc3807ca5ffc0bf8d474dbadaa1f1b7c61bd

    def initialize(id:,
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

      @start_time = Time.parse(start_time)
      @end_time = Time.parse(end_time)

      if @end_time.to_i < @start_time.to_i
        raise ArgumentError, "end time is before start time"
      end
      @cost = cost
      @rating = rating

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

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def duration
      second = @end_time - @start_time
      return second.to_i
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
             )
    end
  end
end
