require 'csv'
require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :status, :trips

    STATUS = [:AVAILABLE, :UNAVAILABLE]

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)
      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []

      if vin.length != 17
        raise ArgumentError, "VIN cannot be less than 17 numbers. try again."
      end

      if !(STATUS.include?(status))
        raise ArgumentError, "Status must be either Available or Unavailable."
      end
    end

    



  end # Class end
end # Module end