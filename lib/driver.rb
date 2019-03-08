require "csv"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

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

    def add_trip(trip)
      @trips << trip
    end

    def accept_trip(trip)
      add_trip(trip)
      @status = :UNAVAILABLE
    end

    def average_rating
      return 0 if @trips.length == 0
      sum = 0.0
      count_completed_trips = 0
      @trips.each do |trip|
        if trip.rating != nil
          sum += trip.rating
          count_completed_trips += 1
        end
      end
      return sum / count_completed_trips
    end

    def total_revenue
      sum = 0.0
      @trips.each do |trip|
        if trip.cost != nil && trip.cost > 1.65
          sum += (trip.cost - 1.65)
        end
      end
      if @trips.length == 0
        return 0
      else
        return (sum * 0.8).round(2)
      end
    end

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
