require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    def initialize(id:, name:, vin:, status: nil, trips: nil)
    end
  end
end
