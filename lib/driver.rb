require "csv"
require "time"

require_relative "csv_record"
require_relative "trip"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    DRIVE_STATUS = [:AVAILABLE, :UNAVAILABLE]
    VIN_LENGTH = 17

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      (vin.length == VIN_LENGTH) ? (@vin = vin) : (raise ArgumentError, "VIN must 17 characters")
      DRIVE_STATUS.include?(status) ? (@status = status) : (raise ArgumentError, "Invalid status")
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      sum_of_rating = 0
      @trips.each do |trip|
        sum_of_rating += trip.rating
      end
      if @trips.length.zero?
        return 0
      else
        return sum_of_rating.to_f / @trips.length
      end
    end

    def total_revenue
      revenue = 0
      @trips.each do |trip|
        revenue += trip.cost
      end
      if @trips.length.zero?
        return 0
      else
      return driver_take_home = (revenue - (1.65 * @trips.length)) * 0.8
    end

    def accept_trip(trip)
      @status = :UNAVAILABLE
      @trips.push(trip)
    end

    # private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
             )
    end
  end
end
