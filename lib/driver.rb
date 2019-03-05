require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def intialize(id, name, vin, status, trips)
      super(id)
      @name = name
      raise ArgumentError, "vin must be 17 characters long" if vin.length != 17
      @vin = vin
      raise ArgumentError, "status must be AVALIBLE OR UNAVALIBLE" if status != :AVALIBLE || status != :UNAVALIBLE
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
