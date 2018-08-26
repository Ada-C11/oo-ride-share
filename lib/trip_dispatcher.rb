require 'csv'
require 'time'

require_relative 'user'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
                   trip_file = 'support/trips.csv',
                   driver_file = 'support/drivers.csv')
      @passengers = load_users(user_file)
      @drivers = load_drivers(driver_file)
      @trips = load_trips(trip_file)
    end

    def load_users(filename)
      users = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:phone] = line[2]

        users << User.new(input_data)
      end

      return users
    end

    def load_drivers(filename)
      drivers = []

      CSV.read(filename, headers: true).each do |line|
        id = line['id'].to_i
        passenger = find_passenger(id)
        driver = Driver.new(id: passenger.id, name: passenger.name,
                            phone: passenger.phone_number, trips: passenger.trips,
                            vin: line['vin'], status: line['status'].to_sym)
        drivers << driver

      end
      return drivers
    end


    def load_trips(filename)
      trips = []
      trip_data = CSV.open(filename, 'r', headers: true,
                                          header_converters: :symbol)

      trip_data.each do |raw_trip|
        passenger = find_passenger(raw_trip[:passenger_id].to_i)
        driver = find_driver(raw_trip[:driver_id].to_i)

        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          driver: driver,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        driver.add_driven_trip(trip)
        trips << trip
      end

      return trips
    end

    def find_passenger(id)
      return find(id, @passengers)
    end

    def find_driver(id)
      return find(id, @drivers)
    end

    def request_trip(user_id)
      passenger = find_passenger(user_id)

      available_driver = drivers.find do |driver|
        driver.status == :AVAILABLE
      end

      raise Error, "No Available Drivers" if available_driver.nil?

      available_driver.status = :UNAVAILABLE

      trip = Trip.new(passenger: passenger, start_time: Time.now,
                      driver: available_driver)
      passenger.add_trip(trip)
      driver.add_driven_trip(trip)
    end

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end


    private

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end

    def find(id, array)
      check_id(id)
      return array.find { |user| user.id == id }
    end
  end
end
