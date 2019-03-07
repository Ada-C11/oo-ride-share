require "csv"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      raise ArgumentError, "invalud VIN length" if vin.length != 17
      @vin = vin
      @status = status
      status_options = [:AVAILABLE, :UNAVAILABLE]
      raise ArgumentError, "invalid status" if status_options.include?(status) == false
      @trips = trips || []
    end

    # will revisit
    def add_trip(trip)
      @trips << trip
    end

    # Add a trip to the driver's list of trips
    # Try adding a trip

    def average_rating
      return 0 if @trips.length == 0
      sum = 0.0
      @trips.each do |trip|
        sum += trip.rating
      end
      return sum / @trips.length
    end

    # What is this driver's average rating?	What if there are no trips?

    # Does it handle floating point division correctly? For example the average of 2 and 3 should be 2.5, not 2.

    def total_revenue
      sum = 0.0
      @trips.each do |trip|
        if trip.cost > 1.65
          sum += trip.cost
        end
      end
      if @trips.length == 0
        return 0
      else
        return ((sum - 1.65) * 0.8).round(2)
      end
    end

    # This method calculates that driver's total revenue across all their trips.
    # Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.
    # What if there are no trips?

    # What if the cost of a trip was less that $1.65?

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end
end
