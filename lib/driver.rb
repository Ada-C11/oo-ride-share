require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    
    def initialize(id:, name:, vin:, status:, trips: []) 
      super(id)
      @name = name
      
      if vin.length == 17
        @vin = vin 
      else 
        raise ArgumentError, "The vin length is incorrect."
      end
      unless status == :AVAILABLE || status == :UNAVAILABLE
        raise ArgumentError, "Status must be :AVAILABLE or :UNAVAILABLE"
      end
      @trips = trips 
    end

    private 

    def self.from_csv(record)
      return new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status]
             )
    end
    
  end
end
