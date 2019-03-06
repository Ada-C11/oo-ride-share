require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []

      raise ArgumentError.new("Invalid Vin") if @vin.length != 17 
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      rating_total = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          rating_total += trip.rating
        end
      return rating_total/@trips.length.to_f.round(2)
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
