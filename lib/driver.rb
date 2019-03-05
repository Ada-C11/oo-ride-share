require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)
      @name = name
      @vin = vin
      if vin.length != 17
        raise ArgumentError, "VIN must be 17 digits."
      end
      @status = status
      @trips = trips || []
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
