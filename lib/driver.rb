require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips
    attr_accessor :status
    VALID_STATUSES = [:AVAILABLE, :UNAVAILABLE]
    VIN_LENGTH = 17

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name

      (vin.length == VIN_LENGTH) ? (@vin = vin) : (raise ArgumentError, "VIN must be string of length 17")

      VALID_STATUSES.include?(status) ? (@status = status) : (raise ArgumentError, "Invalid status")

      @trips = trips || []
    end

    def add_trip(trip)
      trips << trip
    end

    def average_rating
      if trips.length == 0
        return 0
        # Accounts for case where driver's first trip is in progress
      elsif trips.length == 1 && !trips.first.rating
        return 0
      else
        average_total = trips.reduce(0) do |total, trip|
          trip.rating ? (total + trip.rating) : total
        end
        average_rating = average_total.to_f / (trips.count { |trip| trip.rating })
        return average_rating.round(2)
      end
    end

    def total_revenue
      if trips.length == 0
        return 0
        # Accounts for case where driver's first trip is in progress
      elsif trips.length == 1 && !trips.first.rating
        return 0
      else
        gross_revenue = trips.reduce(0) do |total, trip|
          trip.cost ? (total + trip.cost.to_f) : total
        end
      end

      # If the ride cost is greater than 1.65, 1.65 is subtracted in fees.
      # If the cost is less than $1.65, the total cost of the trip is subtracted in fees (no revenue)
      fees = (trips.count { |trip| (trip.cost && trip.cost >= 1.65) } * 1.65) +
             (trips.reduce(0) { |total, trip| (trip.cost && trip.cost < 1.65) ? (total + trip.cost.to_f) : total })

      total_revenue = (gross_revenue.to_f - fees) * 0.8
      return total_revenue.round(2)
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
