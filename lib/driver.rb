require "csv"
require "pry"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin
    attr_accessor :status, :trips

    STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []

      if vin.length != 17
        raise ArgumentError, "VIN cannot be less than 17 numbers. try again."
      end

      if !(STATUS.include?(status))
        binding.pry
        raise ArgumentError, "Status must be either Available or Unavailable."
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      this_drivers_ratings = []
      @trips.map { |trip| this_drivers_ratings << trip.rating.to_f}

      begin
        avg = this_drivers_ratings.sum / this_drivers_ratings.length
        return avg
      rescue ZeroDivisionError
        avg = 0.0
      end
    end
    
    def total_revenue
      revenue = 0.0
      @trips.each do |trip|
        if trip.cost == nil
          revenue += 0
        elsif
          trip.cost < 1.65
          revenue += 0
        else 
          revenue += ((trip.cost - 1.65) * 0.8).round(2)
        end
      end
      return revenue
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end # Class end
end # Module end
