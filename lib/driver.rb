require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      if vin.length != 17
        raise ArgumentError, "VIN must be 17 characters"
      end
      @vin = vin
      @status = status.to_sym
      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError, "Status must either be :AVAILABLE or :UNAVAILABLE."
      end
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      total = 0.0
      self.trips.each do |trip|
        total += trip.rating
      end
      if self.trips.length == 0
        return 0
      else
        return total / self.trips.length
      end
    end

    def total_revenue
      revenue = 0
      self.trips.each do |trip|
        if trip.cost > 1.65
          revenue += (trip.cost - 1.65) * 0.8
        end
      end
      return revenue.truncate(2)
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
