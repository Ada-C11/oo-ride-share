require_relative "csv_record"
# require_relative "trip"
# require_relative "trip_dispatcher"

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status
      @trips || []
    end
  end
end
