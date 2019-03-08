require "csv"

require_relative "trip_dispatcher"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips
    attr_accessor :driver

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      avail_statuses = [:AVAILABLE, :UNAVAILABLE]
      @name = name

      if vin.length == 17
        @vin = vin
      else
        raise ArgumentError, "VIN must be string of length 17"
      end

      if avail_statuses.include?(status)
        @status = status
      else
        raise ArgumentError, "Invalid status"
      end
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if trips.length == 0
        return 0
      end

      nil_ratings = 0
      all_ratings_sum = 0

      @trips.each do |trip|
        if trip.rating == nil
          nil_ratings += 1
        else
          all_ratings_sum += trip.rating.to_f
        end
      end
      return (all_ratings_sum / (trips.length - nil_ratings)).to_f
    end

    def total_revenue
      driver_take_home = 0
      cost_after_deduction = 0
      if trips.length == 0
        return 0
      end

      @trips.each do |trip|
        if trip.cost == nil
          next
        elsif trip.cost <= 1.65
          cost_after_deduction = trip.cost
          driver_take_home += cost_after_deduction
        else
          cost_after_deduction = trip.cost - 1.65
          driver_take_home += cost_after_deduction
        end
      end
      driver_take_home *= 0.8
      return driver_take_home.to_f
    end

    def change_status(new_trip)
      if new_trip.driver_id == self.id
        self.add_trip(new_trip)
        @status = :UNAVAILABLE
      end
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
