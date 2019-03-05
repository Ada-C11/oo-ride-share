require "csv"
require "time"

require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, :name, :vin, :status, :trips)
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

    end

    def add_trip
    end

    def avg_rating
    end

    def total_revenue
    end

    def net_expenditures
    end
    
end

