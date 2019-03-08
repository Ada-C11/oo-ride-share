require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips
    
    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || [] # trips is set to empty array when nil
    end

    def add_trip(trip)
      @trips << trip
    end
    
    def total_time_spent 
      if @trips.length == 0
        raise ArgumentError, "Passenger has no trips."
      end
      
      total_minutes = (@trips.map{|trip| trip.duration}).sum
        return "#{total_minutes} minutes"
    end

    def net_expenditures
      if @trips.length == 0
        raise ArgumentError, "Passenger has no trips."
      else
        return @trips.map{|trip| 
          unless trip.end_time == nil # ignore in-progress trips
            trip.cost
          end}.sum
      end
    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
