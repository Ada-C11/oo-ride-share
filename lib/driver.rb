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
      unless status = :AVAILABLE || status = :UNAVAILABLE
        raise ArgumentError, "Status must either be :AVAILABLE or :UNAVAILABLE."
      end
      @status = status
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
