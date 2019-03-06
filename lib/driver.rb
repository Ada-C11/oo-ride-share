require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      if vin.length != 17
        raise ArgumentError, "VIN must be 17 digits."
      end
      @status = status.to_sym
      # REMEMBER: raise an error if not AVAILABLE, UNAVAILABLE
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips == nil # not working, needs attention
        return 0
      elsif ratings = @trips.map do |trip|
        trip.rating.to_f
      end
      end

      return ratings.sum / ratings.length
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
