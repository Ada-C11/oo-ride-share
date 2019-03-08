require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin
    attr_accessor :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

      @name = name
      @vin = vin
      @status = status.to_sym
      @trips = trips || []

      raise ArgumentError, 'Invalid Vin' if @vin.length != 17
    end

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      rating_total = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          rating_total += trip.rating unless trip.rating.nil?
        end
        return rating_total / @trips.length.to_f.round(2)
      end
    end

    def total_revenue
      total_revenue = 0
      if @trips.empty?
        return 0
      else
        @trips.each do |trip|
          if trip.cost >= 1.65
            total_revenue += trip.cost * 0.8 - 1.65
          else
            total_revenue
          end
        end
      end

      total_revenue
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
