require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)
      status = status.to_sym
      @name = name
      raise ArgumentError, "vin must be 17 characters long" if vin.length != 17
      @vin = vin
      if ![:AVAILABLE, :UNAVAILABLE].include?(status)
        raise ArgumentError, "status must be AVAILABLE OR UNAVAILABLE. got: #{status}"
      end
      @status = status
      @trips = trips || []
    end

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
