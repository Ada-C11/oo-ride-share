require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: "AVAILABLE", trips: nil)
      super(id)
      status = status.to_sym
      @name = name
      raise ArgumentError, "vin must be 17 characters long" if vin.length != 17
      @vin = vin
      if ![:AVAILABLE, :UNAVAILABLE].include?(status)
        raise ArgumentError, "status must be AVAILABLE OR UNAVAILABLE. got: #{status}"
      end
      @status = status
      @trips = trips || []
    end

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
             )
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      average = @trips.sum { |trip| trip.rating }
      if @trips.length == 0
        return 0
      else
        return average / @trips.length.to_f
      end
    end

    def total_revenue
      total = @trips.sum do |trip|
        cost = ((trip.cost - 1.65) * 0.8).round(2)
        cost = 0 if cost < 0 || !cost
        cost
      end
      return total
    end

    def start_trip(trip)
      @status == :AVAILABLE ? @status = :UNAVAILABLE : @status = :AVAILABLE
      add_trip(trip)
    end
   
  

  end
end
