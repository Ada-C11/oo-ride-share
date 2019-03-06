require "csv"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      raise ArgumentError, "Invalid VIN" if vin.length != 17
      @vin = vin
      raise ArgumentError, "Invalid Status" if [:AVAILABLE, :UNAVAILABLE].include?(status) == false
      @status = status
      @trips = trips || []
    end

    def id
      return @id
    end

    def add_trip(trip)
      @trips << trip
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
