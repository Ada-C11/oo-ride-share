require "csv"
require "pry"
require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status

    STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []

      if vin.length != 17
        raise ArgumentError, "VIN cannot be less than 17 numbers. try again."
      end

      if !(STATUS.include?(status))
        binding.pry
        raise ArgumentError, "Status must be either Available or Unavailable."
      end
    end

    def add_trip(trip)
      @trips << trip
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
  end # Class end
end # Module end
