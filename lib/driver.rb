require "csv"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @valid_statuses = [:AVAILABLE, :UNAVAILABLE]
      @name = name
      raise ArgumentError, "Invalid VIN" if vin.length != 17
      @vin = vin
      raise ArgumentError, "Invalid Status" if @valid_statuses.include?(status) == false
      @status = status
      @trips = trips || []
    end

    def id
      return @id
    end

    def add_trip(trip)
      @trips << trip
    end

    #average_rating method
    def average_rating
      if @trips.length == 0
        0
      else
        @trips.sum{ |trip| trip.rating.to_f } / @trips.length
      end
    end
    #total revenue method
    def total_revenue
      @trips.sum{ |trip| 0.8 * (trip.cost - 1.65) }
    end

    def self.from_csv(record)
      return self.new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status].to_sym,
      )
    end
  end
end
