require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    
    def initialize(id, name, vin, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      self.class.validate_vin(vin)
      @vin = vin
      self.class.validate_status(status)
      @status = status
      @trips = trips || []
    end

    def self.validate_vin(vin)
      unless vin.length == 17
        raise ArgumentError, "Vin must have 17 characters"
      end
    end

    def validate_status(status)
      unless status == :AVAILABLE || status == :UNAVAILABLE
        raise ArgumentError, "Must have valid status"
      end
    end
  end
end