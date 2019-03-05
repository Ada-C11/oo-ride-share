require_relative "csv_record"
require "csv"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
        super(id)
  
        @name = name
        @vin = vin
        @status = status
        @trips = trips || []

        if vin.length != 17
            raise ArgumentError, "Invalid vin #{vin}."
        end

        unless STATUS.include?(status)
            raise ArgumentError, "Invalid status #{status}."
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