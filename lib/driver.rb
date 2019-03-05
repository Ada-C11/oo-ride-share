require "csv"

require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE)
      super(id)

      @name = name
      @trips = trips || []
      @status = :AVAILABLE || :UNAVAILABLE

      if vin.length != 17
        raise ArgumentError, "Invalid VIN"
      else
        @vin = vin
      end
      
    end



    private

    def self.from_csv(record)
      return self.new(
               id: record[:id],
               name: record[:name],
               vin: record[:vin],
               status: record[:status],
             )
    end





  end

end
