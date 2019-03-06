require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      @name = name

      if vin.length == 17
        @vin = vin
      else
        raise ArgumentError, "The vin length is incorrect."
      end

      # status_possibilities = [:AVAILABLE, :UNAVAILABLE]

      unless status == :AVAILABLE || status == :UNAVAILABLE
        raise ArgumentError, "Status must be :AVAILABLE or :UNAVAILABLE. It's: #{status}"
      end

      @status = status
      @trips = trips
    end

    def add_trip(trip)
      trips << trip
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status].to_sym,
             )
    end
  end
end
