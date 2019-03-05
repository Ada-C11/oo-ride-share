require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      if vin.length != 17
        raise ArgumentError, "Vin length is too short"
      else
        @vin = vin
      end
      unless [:UNAVAILABLE, :AVAILABLE].include?(status.to_sym)
        raise ArgumentError, "Invalid status"
      else
        @status = status.to_sym
      end
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      sum = 0
      trips.each do |trip|
        sum += trip.rating
      end
      average = trips.count == 0 ? 0 : sum.to_f / trips.count
      return average
    end

    def total_revenue
      sum = 0
      trips.each do |trip|
        sum = trip.cost > 1.65 ? (sum + ((trip.cost - 1.65) * 0.8)) : sum
      end
      return sum
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
