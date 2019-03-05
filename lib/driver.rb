require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
      @name = name
      if vin.length != 17
        raise ArgumentError, "Vin length is too short"
      else
        @vin = vin
      end
      unless [:UNAVAILABLE, :AVAILABLE].include?(status)
        raise ArgumentError, "Invalid status"
      else
        @status = status
      end
      @trips = trips
    end

    private

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
             )
    end
  end
end
