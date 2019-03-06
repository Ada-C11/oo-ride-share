require "csv"
require "time"

require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE)
      super(id)

      @name = name
      @trips = []
      @status = status.to_sym

      #vin argument error thing
      if vin.length != 17 || vin.nil?
        raise ArgumentError, "Vin must be exactly 17 characters"
      else
        @vin = vin
      end

      raise ArgumentError, "Driver must have a status of AVAILABLE or UNAVAILABLE" if status != ( :AVAILABLE || :UNAVAILABLE ) && status.nil?

    end
    def add_trip(trip)
      @trips << trip
    end
    private

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
