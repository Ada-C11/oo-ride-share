require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :phone_number, :trips, :vin, :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      if @vin.length != 17
        raise ArgumentError, "Invalid vin number"
      end
    end

    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:vin],
             )
    end
  end
end
