require "csv"
require "time"

require_relative "csv_record"
require_relative 'trip'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    DRIVE_STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      if vin.length != 17 || nil
        return raise ArgumentError, "Invalid VIN"
      end
      @status = status.to_sym # changed to sym
      if DRIVE_STATUS.include?(@status) == false # changed to @ status
        return raise ArgumentError, "Invalid Status"
      end
      @trips = trips || []
    end

    # added the add trip methods
    def add_trip(trip)
      @trips << trip
    end

    # added the avg rating method
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

    # calculated the driver take home revenue
    # This method calculates that driver's total revenue across all their trips. 
    # Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.
    def total_revenue
      revenue = 0
      @trips.each do |trip|
        revenue += trip.cost
      end
      driver_take_home = (revenue - (1.65 * @trips.length)) * 0.8
      return driver_take_home
    end


    # def net_expenditures
    # end

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
