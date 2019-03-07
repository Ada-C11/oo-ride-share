require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :phone_number, :trips, :vin, :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      if @vin.length != 17
        raise ArgumentError, "Invalid vin number"
      end
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips.length == 0
        return 0
      else
        return @trips.sum { |trip| trip.rating } / @trips.length.to_f
      end
    end

    def total_revenue
      # if @trips.length == 0
      #   return 0
      # else
      driver_revenue = @trips.map do |trip|
        if trip.cost > 1.65
          trip.cost - 1.65
        else
          trip.cost
        end
      end
      # end

      return (driver_revenue.sum * 0.8).round(2)
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end
end
