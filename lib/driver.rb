require "csv"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    STATUS_OPTIONS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)

      @name = name
      #   raise ArgumentError, "invalud VIN length" if vin.length != 17
      @vin = vin
      #   raise ArgumentError, "invalid status" if status.include?(STATUS_OPTIONS) == false
      @status = status
      @trips = trips || []
    end

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
