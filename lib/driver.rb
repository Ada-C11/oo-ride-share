require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      raise ArgumentError, "Invalid VIN: #{vin}" unless @vin.length == 17
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if @trips.empty?
        return 0
      else
        average_rating = 0
        @trips.each do |trip|
          average_rating += trip.rating
        end
    end

      average_rating /= @trips.length
      average_rating.to_f
    end

    def total_revenue
      if @trips.empty?
        return 0
      else
        total_revenue = 0
        @trips.each do |trip|
          total_revenue += (trip.cost - 1.65)
        end
      end
      total_revenue *= 0.8
      return total_revenue
    end

    private

    def self.from_csv(record)
      new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end
  end
end
