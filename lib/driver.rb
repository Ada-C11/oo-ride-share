require_relative "csv_record"
require "csv"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips: nil)
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
      @status = status
      @trips = trips
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
