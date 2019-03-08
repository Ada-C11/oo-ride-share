require "csv"
require "time"

require_relative "csv_record"
require_relative 'trip'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips, :last_end_time

    DRIVE_STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @last_end_time = nil
      @vin = vin
      if vin.length != 17 || nil
        return raise ArgumentError, "Invalid VIN"
      end
      @status = status.to_sym
      if DRIVE_STATUS.include?(@status) == false
        return raise ArgumentError, "Invalid Status"
      end
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
      return driver_take_home = (revenue - (1.65 * @trips.length)) * 0.8
    end

    def accept_trip(trip)
      @last_end_time = trip.end_time
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
