require "csv"
require "time"
require_relative "csv_record"

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    def initialize(id:,
                   passenger: nil, passenger_id: nil,
                   start_time:, end_time:, cost: nil, rating:, driver: nil, driver_id: nil)
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, "Passenger or passenger_id is required"
      end
      @start_time = Time.parse(start_time)
      if !end_time.nil?
        @end_time = Time.parse(end_time)
        #if end time is before start time, raise an argument error
        if @start_time > @end_time
          raise ArgumentError
        end
      else
        @end_time = nil
      end

      @cost = cost
      @rating = rating
      if !rating.nil?
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
      @driver = driver
      @driver_id = driver_id
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def duration_seconds
      if @end_time == nil
        return nil
      else
        return @end_time - @start_time
      end
    end

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def connect_driver(driver)
      @driver = driver
      driver.add_trip(self)
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               driver_id: record[:driver_id],
               passenger_id: record[:passenger_id],
               start_time: record[:start_time],
               end_time: record[:end_time],
               cost: record[:cost],
               rating: record[:rating],
             )
    end
  end
end

# start_time = Time.parse("2015-05-20T11:04:00+00:00")
# # end_time = start_time + 25 * 60 # 25 minutes
# end_time = Time.parse("2015-05-20T12:02:00+00:00")
# trip_data = {
#   id: 8,
#   passenger: RideShare::Passenger.new(id: 1,
#                                       name: "Ada",
#                                       phone_number: "412-432-7640"),
#   start_time: start_time.to_s,
#   end_time: end_time.to_s,
#   cost: 23.45,
#   rating: 3,
# }
# # trip = RideShare::Trip.new(trip_data)
# # puts trip.duration_seconds
