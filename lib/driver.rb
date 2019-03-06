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
      average_rating = @trips[:rating].sum.to_f / @trips[:rating].count.to_f
      return average_rating
    end

    # calculates driver's total revenue across all trips. each driver gets 80% of trip cost after a fee of 1.65 is deducted
    def total_revenue
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
