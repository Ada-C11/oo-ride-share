
require "csv"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

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
      nil_counter = 0
      total_ratings = 0.0
      if trips.length == 0
        return nil
      end
      @trips.each do |trip|
        if trip.rating == nil
          nil_counter += 1
        else
          total_ratings += trip.rating
        end
      end
      return (total_ratings / (trips.length - nil_counter)).to_f
    end

    def change_driver_status
      @status = :UNAVAILABLE
    end

    def total_revenue
      driver_take_home = 0
      cost_after_deduction = 0
      if trips.length == 0
        return nil
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
