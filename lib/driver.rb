require_relative "csv_record"
# require_relative "passenger"
# require_relative "trip"
# require_relative "trip_dispatcher"
require "pry"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      raise ArgumentError if vin.length != 17
      @vin = vin
      @status = status
      #   binding.pry
      if status == :AVAILABLE
      elsif status == :UNAVAILABLE
      else
        raise ArgumentError
      end
      @trips ||= []
    end

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end

    def add_trip(trip)
      @trips << trip
    end
  end
end
