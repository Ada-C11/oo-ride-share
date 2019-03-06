require_relative "csv_record"
require "csv"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      if vin.length != 17
        raise ArgumentError, "Invalid vin #{vin}."
      end

      unless STATUS.include?(status)
        raise ArgumentError, "Invalid status #{status}."
      end

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
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
