require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
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
      @trips = trips
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
