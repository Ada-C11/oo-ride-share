require "csv"
require "time"
# require_relative "passenger"
require_relative "csv_record"

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating

    def initialize(id:,
                   passenger: nil, passenger_id: nil,
                   start_time:, end_time:, cost: nil, rating:)
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
      @end_time = Time.parse(end_time)
      #if end time is before start time, raise an argument error
      if @start_time > @end_time
        raise ArgumentError
      end
      @cost = cost
      @rating = rating

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def duration_seconds
      hour_to_seconds = (@end_time.hour - @start_time.hour) * 60 * 60
      minutes_to_seconds = (@end_time.min - @start_time.min) * 60
      seconds = @end_time.sec - start_time.sec
      total_duration_sec = hour_to_seconds + minutes_to_seconds + seconds
      puts @end_time
      puts @start_time
      return total_duration_sec
    end

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               passenger_id: record[:passenger_id],
               start_time: record[:start_time],
               end_time: record[:end_time],
               cost: record[:cost],
               rating: record[:rating],
             )
    end
  end
end

start_time = Time.parse("2015-05-20T11:04:00+00:00")
# end_time = start_time + 25 * 60 # 25 minutes
end_time = Time.parse("2015-05-20T12:02:00+00:00")
trip_data = {
  id: 8,
  passenger: RideShare::Passenger.new(id: 1,
                                      name: "Ada",
                                      phone_number: "412-432-7640"),
  start_time: start_time.to_s,
  end_time: end_time.to_s,
  cost: 23.45,
  rating: 3,
}
# trip = RideShare::Trip.new(trip_data)
# puts trip.duration_seconds
