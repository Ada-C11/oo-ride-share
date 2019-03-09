require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      if vin.length != 17
        raise ArgumentError, "VIN must be 17 digits."
      end
      @status = status.to_sym
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def change_status(trip)
      self.status = :UNAVAILABLE
    end

    def average_rating
      if @trips.length != 0
        ratings = @trips.map do |trip|
          trip.rating.to_f
        end
      else
        return 0
      end

      return ratings.sum / ratings.length
    end

    def total_revenue
      if @trips.length != 0
        revenue = @trips.map do |trip|
          if trip.cost >= 1.65
            (trip.cost - 1.65)
          else
            0
          end
        end
        return (revenue.sum * 0.8).round(2)
      else
        return 0
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
