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

    # need to add test for end time is nil, should test must_close to
    def average_rating
      if @trips.length == 0
        return 0
      end

      sum_rating = @trips.sum { |trip| trip.rating }.to_f.round(2)

      return sum_rating / completed_trips
    end

    def completed_trips
      num_trips = @trips.length.to_f.round(2)
      @trips.each do |trip|
        if trip.end_time == nil
          num_trips -= 1.00
        end
      end
      return num_trips
    end

    # test must close to
    def total_revenue
      if @trips.nil?
        return 0.00
      end

      total_fees = 1.65 * completed_trips
      # will this raise an error for cost equals nil?
      sum_costs = @trips.sum { |trip|
        if trip.cost == nil
          next
        end
        trip.cost
      }

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
