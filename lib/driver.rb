require_relative "csv_record"
require "csv"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

    STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips

      if vin.length != 17
        raise ArgumentError, "Invalid vin #{vin}."
      end

      if !STATUS.include?(@status)
        raise ArgumentError, "Invalid status #{@status}."
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      rating = 0

      @trips.each do |trip|
        rating += trip.rating.to_f
      end

      return @trips.length > 0 ?
               (rating / @trips.length) : rating
    end

    def total_revenue
      revenue = 0

      @trips.each do |trip|
        if trip.cost < 1.65
          revenue += 0
        else
          revenue += ((trip.cost - 1.65) * 0.8)
        end
      end

      return revenue.to_f
    end

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
             )
    end

    def change_status(trip)
      @status == :AVAILABLE ? @status = :UNAVAILABLE : @status = :AVAILABLE
      add_trip(trip)
    end

  end
end
