require "csv"
require "time"

require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    DRIVE_STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      if vin.length != 17 || nil
        return raise ArgumentError, "Invalid VIN"
      end
      @status = status
      if DRIVE_STATUS.include?(status) == false
        return raise ArgumentError, "Invalid Status"
      end
      @trips = trips || []
    end

    # def add_trip
    #     # @trips << trip
    # end

    # def avg_rating
    # end

    # def total_revenue
    # end

    # def net_expenditures
    # end

    # private

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
