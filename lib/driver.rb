require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :vin, :status

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)

      @vin = vin
      @status = status
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
