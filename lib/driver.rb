require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      self.class.validate_vin(vin)
      @vin = vin
      self.class.validate_status(status)
      @status = status
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      total = 0
      if trips.length == 0 || trips.length == nil
        return 0
      else
        @trips.each do |trip|
          total += trip.rating.to_f
        end
        return total / @trips.length
      end
    end

    def self.validate_vin(vin)
      unless vin.length == 17
        raise ArgumentError, "Vin must have 17 characters"
      end
    end

    def self.validate_status(status)
      unless status == :AVAILABLE || status == :UNAVAILABLE
        raise ArgumentError, "Must have valid status"
      end
    end

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
             )
    end
  end
end
