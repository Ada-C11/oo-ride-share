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

      sum_rating = @trips.sum { |trip| trip.rating }.to_f.round(1)
      num_trips = @trips.length.to_f.round(1)

      return sum_rating / num_trips
    end

    def total_revenue
      if @trips.nil?
        return 0.00
      end

      total_fees = 1.65 * @trips.length.to_f.round(2)
      sum_costs = @trips.sum { |trip| trip.cost }

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
