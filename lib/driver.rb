require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin.length == 17 ? vin : (raise ArgumentError.new("Invalid Vin: #{vin.length} length"))
      @status = status
      if ![:AVAILABLE, :UNAVAILABLE].include? (status)
        raise ArgumentError, "Invalid Status"
      end

      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating(completed_trips = non_inprogress_trips)
      average_rating = completed_trips.sum do |trip|
        trip.rating
      end
      average_rating /= completed_trips.length.to_f if completed_trips.length > 0
      return average_rating
    end

    def non_inprogress_trips
      return trips.select do |trip|
               trip.end_time
             end
    end

    def total_revenue
      return @trips.sum do |trip|
               (trip.cost - 1.65) * 0.80
             end
    end

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end
end
