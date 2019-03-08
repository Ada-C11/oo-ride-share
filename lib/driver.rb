require "csv"
require "time"

require_relative "csv_record"

module RideShare
  FEE = 1.65
  PERCENT = 0.8

  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    attr_accessor :status

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

      raise ArgumentError, "Driver must have a status of AVAILABLE or UNAVAILABLE" if status != (:AVAILABLE || :UNAVAILABLE) && status.nil?
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      @ratings_array = []
      if @trips.length > 0
        @trips.each do |trip|
          @ratings_array << trip.rating
        end
        average_rating = @ratings_array.sum / @ratings_array.length
        return average_rating.to_f
      else
        return 0
      end
    end

    def total_revenue
      @revenue = []
      @trips.each do |trip|
        @revenue << trip.cost - FEE
      end
      total_revenue = (@revenue.sum) * PERCENT
      total_revenue.to_f.round(2)
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
