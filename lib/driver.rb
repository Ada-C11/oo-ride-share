require_relative "csv_record"
require "csv"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      if vin.length != 17
        raise ArgumentError, "VIN length is invalid"
      end

      statuses = [:AVAILABLE, :UNAVAILABLE]
      if !statuses.include?(status.to_sym)
        raise ArgumentError, "Status is invalid."
      end

      @id = id
      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips.length == 0
        return 0
      end

      sum_rating = 0.00
      num_ratings = 0
      @trips.each do |trip|
        if !trip.rating.nil?
          sum_rating += trip.rating.to_f.round(2)
          num_ratings += 1
        end
      end

      return sum_rating / num_ratings
    end

    def total_revenue
      total_fees = 0
      sum_costs = 0
      @trips.each do |trip|
        if !trip.cost.nil?
          sum_costs += trip.cost
        end

        if !trip.cost.nil? && trip.cost > 1.65
          total_fees += 1.65
        end
      end

      return (sum_costs - total_fees) * 0.80
    end

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
             )
    end
  end
end
