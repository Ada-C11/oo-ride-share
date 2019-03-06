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

    def average_rating(driver)
      rating = []
      @trips.each do |trip|
        if trip.driver_id == driver.id
          rating << driver.id.rating
        end
      end
      average_rating = rating.reduce(:+) / rating.length.to_f
      return average_rating
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
