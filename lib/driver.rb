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

    def add_trip(trip)
      @trips << trip
    end

    def average_rating
      if trips.length == 0
        return 0
      else
        rating_sum = @trips.reduce(0) do |ratings, trip|
          ratings += trip.rating
        end
        return (rating_sum / trips.length).to_f
      end
    end

    # drivers total revenue = (total sum (1.65 * num of trips)) * .8

    #   rides_net_pay = 0
    #   driver_instance = RideShare::TripDispatcher.find_driver(id)
    #   driver_instance.trips each do |trip|
    #     rides_net_pay += trip.cost
    #   end
    #   driver_take_home = (rides_net_pay * (1.65 * trips.length) * 0.8)
    #   return driver_take_home

    def total_revenue
      driver_take_home = 0
      cost_after_deduction = 0
      if trips.length == 0
        return 0
      else
        @trips.each do |trip|
          cost_after_deduction = trip.cost - 1.65
          driver_take_home += cost_after_deduction
        end
        driver_take_home *= 0.8
      end
      return driver_take_home.to_f
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
