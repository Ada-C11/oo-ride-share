require "csv"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

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

    # will revisit
    def add_trip(trip)
      @trips << trip
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
