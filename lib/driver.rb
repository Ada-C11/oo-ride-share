require_relative "csv_record"
require "csv"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    STATUS = [:AVAILABLE, :UNAVAILABLE]
    def initialize(id:, name:, vin:, status:, trips: nil)
        super(id)
  
        @name = name
        @vin = vin
        @status = status
        @trips = trips || []

        if vin.length != 17
            raise ArgumentError, "String is not 17 long."
        end
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