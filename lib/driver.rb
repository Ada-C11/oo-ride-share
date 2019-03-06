require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      valid_statuses = [:AVAILABLE, :UNAVAILABLE]
      @name = name
      raise ArgumentError, "VIN must be string of length 17" if vin.length != 17
      @vin = vin
      if valid_statuses.include?(status)
        @status = status
      else
        raise ArgumentError, "Invalid status"
      end
      @trips = trips || []
    end

    def add_trip(trip)
      trips << trip
    end

    def average_rating
      if trips.length == 0
        return 0
      else
        average_rating = (trips.reduce(0) { |total, trip| total += trip.rating }.to_f) / trips.length
        return average_rating.round(2)
      end
    end

    def total_revenue
      total_revenue = trips.reduce(0) { |total, trip| total += trip.cost }
      net_revenue = (total_revenue.to_f - (trips.length * 1.65)) * 0.8
      return net_revenue.round(2)
    end

    def assign_trip(trip)
      self.status = :UNAVAILABLE
      add_trip(trip)
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
