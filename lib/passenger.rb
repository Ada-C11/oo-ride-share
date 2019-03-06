require_relative "csv_record"
require "csv"

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips, :driver_id, :driver

    def initialize(id:, name:, phone_number:, trips: nil, driver_id: nil, driver: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
      @driver_id = driver_id
      @driver = driver
    end

    def add_trip(trip)
      @trips << trip
    end

    # def net_expenditures
    #   @trips.reduce(0) do |memo, trip|
    #     puts memo
    #     puts trip.cost == nil
    #     memo + trip.cost
    #   end
    # end

    def net_expenditures
      total = 0
      @trips.each do |trip|
        total += trip.cost
      end
      return total
    end

    def total_time_spent
      return trips.sum do |trip|
               trip.duration
             end
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
