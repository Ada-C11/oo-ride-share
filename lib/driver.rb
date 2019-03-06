require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status:, trips: nil)
      super(id)
      @name = name
      @vin = vin.length == 17 ? vin : (raise ArgumentError.new("Invalid Vin: #{vin.length} length"))
      @status = status
      @trips = trips || []
    end
  end
end
