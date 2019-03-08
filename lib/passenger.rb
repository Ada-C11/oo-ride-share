require_relative "csv_record"

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      #check with the nil
      raise ArgumentError, "Passenger has to trips!" if @trips == []
      cost_array = @trips.select do |trip|
        trip.cost if trip.cost != nil
      end
      return cost_array.sum
    end

    def total_time_spent
      #check with the nil
      raise ArgumentError, "Passenger has to trips!" if @trips == []
      total_time_array = @trips.select do |trip|
        trip.duration if trip.end_time != nil
      end
      return total_time_array.sum
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               phone_number: record[:phone_num],
             )
    end
  end
end
