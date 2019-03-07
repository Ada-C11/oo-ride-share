require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name

      unless vin.length == 17
        raise ArgumentError, "VIN must be 17 characters long!"
      end
      @status = status
      unless [:AVAILABLE, :UNAVAILABLE].include?(status)
        raise ArgumentError, "Status must be AVAILABLE or UNAVAILABLE! Got->  #{status.class}"
      end

      @vin = vin

      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      rating = []
      if @trips.length > 0
        @trips.each do |trip|
          rating << trip.rating
        end
        average_rating = rating.reduce(:+) / rating.length.to_f
        return average_rating
      else
        return 0
      end
    end

    def total_revenue
      total_cost = 0.0
      if @trips.length > 0
        @trips.each do |trip|
          total_cost += trip.cost
        end
        total_rev = (total_cost - 1.65) * 0.8
        if total_cost < 1.65
          total_rev = 0
        end
        return total_rev
      else
        return 0
      end
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: (record[:status]).to_sym,
               trips: record[:trips],
             )
    end
  end
end
