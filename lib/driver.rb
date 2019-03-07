require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin

      raise ArgumentError, "Invalid VIN number length." if @vin.length != 17

      @status = status.to_sym

      raise ArgumentError, "Invalid driver status." if @status != :AVAILABLE && @status != :UNAVAILABLE

      @trips = trips || []
    end

    # add a trip to the driver's list of trips
    def add_trip(trip)
      @trips << trip
    end

    # what is this driver's average rating?
    def average_rating
      return 0 if @trips.length == 0

      ratings = []
      @trips.each do |trip|
        ratings << trip.rating
      end
      average_rating = ratings.sum.to_f / ratings.length.to_f
      return average_rating
    end

    # calculates driver's total revenue across all trips. each driver gets 80% of trip cost after a fee of 1.65 is deducted
    def total_revenue # need to somehow figure out how to indicate length of array
      cost_per_trip = []
      @trips.each do |trip|
        if trip.cost < 1.65
          cost_per_trip << trip.cost * 0.8
        else
          cost_per_trip << (trip.cost - 1.65) * 0.8
        end
      end
      total_income = cost_per_trip.sum.round(2)
      return total_income
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
               trips: record[:trips],
             )
    end
  end
end
