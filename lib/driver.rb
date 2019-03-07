require_relative "csv_record"

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      self.class.validate_vin(vin)
      @vin = vin
      self.class.validate_status(status)
      @status = status
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def change_status
      @status = @status == :AVAILABLE ? :UNAVAILABLE : :AVAILABLE
    end

    def find_available(drivers)
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          driver.change_status
          return driver.id
        end
      end
      raise ArgumentError, "There are no available drivers."
    end

    def average_rating
      total = 0
      if trips.length == 0 || trips.length == nil
        return 0
      else
        @trips.each do |trip|
          total += trip.rating.to_f
        end
        return total / @trips.length
      end
    end

    def total_revenue
      total_revenue = 0
      @trips.each do |trip|
        total_revenue += (trip.cost - 1.65) * 0.8
      end
      return total_revenue
    end

    def self.validate_vin(vin)
      unless vin.length == 17
        raise ArgumentError, "Vin must have 17 characters"
      end
    end

    def self.validate_status(status)
      unless status == :AVAILABLE || status == :UNAVAILABLE
        raise ArgumentError, "Must have valid status"
      end
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
