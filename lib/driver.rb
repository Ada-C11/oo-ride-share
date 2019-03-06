require "csv"
require "time"

require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE)
      super(id)

      @name = name
      #   @vin = vin
      #   @status = status
      @trips = []
      @status = status

      #vin argument error thing
      if vin.length != 17 || vin.nil?
        raise ArgumentError, "Vin must be exactly 17 characters"
      else
        @vin = vin
      end

      if status != :AVAILABLE && status != :UNAVAILABLE
        raise ArgumentError, "Driver must have a valid status, AVAILABLE OR UNAVAILABLE"
      else
        @status = status
      end
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
