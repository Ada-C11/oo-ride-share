require_relative 'csv_record'
require "pry"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      unless status.to_sym == :AVAILABLE || status.to_sym == :UNAVAILABLE
        raise ArgumentError, "Invalid status provided"
      end
      
      unless vin.length == 17
        raise ArgumentError, "Vin number must be 17 characters"
      end  
    end

    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      if @trips.count == 0
        return 0
      end
      return (@trips.map{|trip| trip.rating}.sum).to_f/@trips.count
    end

    def total_revenue
      if @trips.length == 0 
        raise ArgumentError, "Driver has no trips."
      else
        raw_revenue = @trips.map{|trip| 
          unless trip.end_time == nil # ignore in-progress trips
            trip.cost
          end}.sum
        revenue = 0.8 * (raw_revenue - (trips.count * 1.65))
        return revenue
      end
    end

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: (record[:status]).to_sym
      )
    end

    
  end

end