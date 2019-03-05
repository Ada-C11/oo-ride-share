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

    def net_expenditures(passenger)
      cost = 0
      @trips.each do |trip|
        if trip.passenger_id == passenger
          cost += trip.cost
        else
          raise ArgumentError, "The passenger does not have any trips!"
        end
      end
      return cost
    end

    def total_time_spent(passenger)
      #get to trip info
      # subtract start time from end time
      # returning amoung ot time spent

      time_passed = 0
      @trips.each do |trip|
        if trip.passenger_id == passenger
          time_passed += trip.end_time - trip.start_time
        else
          raise ArgumentError, "The passenger does not have any trips!"
        end
      end
      return time_passed
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
