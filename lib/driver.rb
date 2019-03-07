require "csv"

require_relative "trip_dispatcher"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

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
      else
        rating_sum = @trips.reduce(0) do |ratings, trip|
          ratings += trip.rating
        end
        return (rating_sum / trips.length).to_f
      end
    end

    def total_revenue
      driver_take_home = 0
      cost_after_deduction = 0
      if trips.length == 0
        return 0
      else
        @trips.each do |trip|
          cost_after_deduction = trip.cost - 1.65
          driver_take_home += cost_after_deduction
        end
      end
      driver_take_home *= 0.8
      return driver_take_home.to_f
    end

    def change_status(current_driver_id)
      # current_driver = TripDispatcher.find_driver(driver.id)

      # add_trip(request_trip(passenger_id))
      # driver.add_trip(Trip.new(
      #   id: @trips.length + 1,
      #   driver_id: driver.id,
      #   passenger_id: find_passenger(passenger_id),
      #   start_time: Time.now.to_s,
      #   end_time: nil,
      #   cost: nil,
      #   rating: nil,
      # ))
      # find_driver(current_driver_id)
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
