
module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips

    def initialize(input)
      super(input)

      raise ArgumentError, "Vin must be 17 characters long" if input[:vin].length != 17
      raise ArgumentError, "Status should be available or unavailable" unless [:AVAILABLE, :UNAVAILABLE].includes? input[:status]

      @vin = input[:vin]
      @status = input[:status]
      @driven_trips = []

    end

  end
end
