require_relative "csv_record"
# require "csv"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: nil, trips: nil)
      super(id)
      @name = name

      unless vin.length == 17
        raise ArgumentError, "VIN must be 17 characters long!"
      end

      unless ["AVAILABLE", "UNAVAILABLE"].include?(status)
        raise ArgumentError, "Status must be AVAILABLE or UNAVAILABLE! Got : #{status}"
      end

      @vin = vin
      @status = status
      @trips = trips || []
    end

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
               trips: record[:trips],
             )
    end
  end
end
