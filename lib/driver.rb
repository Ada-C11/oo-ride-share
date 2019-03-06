require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin.length == 17 ? vin : (raise ArgumentError.new("Invalid Vin: #{vin.length} length"))
      @status = status
      if ![:AVAILABLE, :UNAVAILABLE].include? (status)
        raise ArgumentError, "Invalid Status"
      end

      @trips = trips || []
    end

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
