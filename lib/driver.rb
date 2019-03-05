require "csv"
require "time"

require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(:id, :name, :vin, :status = :AVAILABLE)
      super(id)
      @name = name
      @vin = vin
      @status = status.upcase
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
                 vin: record[:vin]
                 status: record[:status],
               )
      end
end

