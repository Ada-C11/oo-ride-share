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
        average_total = trips.reduce(0) do |total, trip|
          if trip.rating
            total + trip.rating
          else
            total
          end
        end
        average_rating = average_total / (trips.count { |trip| trip.rating })
        return average_rating
      end
    end

    def total_revenue
      total_revenue = trips.reduce(0) do |total, trip|
        if trip.cost
          total + trip.cost
        else
          total
        end
      end
      net_revenue = (total_revenue.to_f - (trips.count { |trip| trip.cost } * 1.65)) * 0.8
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
