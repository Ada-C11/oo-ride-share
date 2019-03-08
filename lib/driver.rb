require_relative "csv_record"
require "pry"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      raise ArgumentError if vin.length != 17
      @vin = vin
      @status = status
      if status == :AVAILABLE
      elsif status == :UNAVAILABLE
      else
        raise ArgumentError
      end
      @trips ||= []
    end

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      sum_rating = 0
      if trips.length == 0
        return 0
      end
      trips.each do |trip|
        if trip.rating != nil
          sum_rating += trip.rating
        end
      end
      return sum_rating.to_f / trips.count { |trip| trip.cost != nil }
    end

    def driver_trip_status_after_trip_request(trip)
      add_trip(trip)
      @status = :UNAVAILABLE
    end

    def total_revenue
      sum_revenue = 0
      if trips.length == 0
        return 0
      end
      trips.each do |trip|
        if trip.cost != nil
          sum_revenue += (trip.cost - 1.65) * 0.8
        end
      end
      return sum_revenue
    end
  end
end
