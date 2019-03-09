require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      @name = name

      if vin.length == 17
        @vin = vin
      else
        raise ArgumentError, "The vin length is incorrect."
      end

      unless status == :AVAILABLE || status == :UNAVAILABLE
        raise ArgumentError, "Status must be :AVAILABLE or :UNAVAILABLE. It's: #{status}"
      end

      @status = status
      @trips = trips
    end

    def add_trip(trip)
      trips << trip
    end

    def average_rating
      total = 0.0
      if finished_trips.length == 0
        return 0
      end
      finished_trips.each do |trip|
        total += trip.rating
      end
      return total / finished_trips.length
    end

    def total_revenue
      total = 0.0
      if trips.length == 0
        return 0
      end
      trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def assign_trip(new_trip)
      new_trip.driver.status = :UNAVAILABLE
      new_trip.driver.add_trip(new_trip)
    end

    private

    def finished_trips
      trips.select { |trip| trip.rating != nil }
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
