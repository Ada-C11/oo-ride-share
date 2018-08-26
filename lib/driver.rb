
module RideShare
  class Driver < User
    attr_reader :vin

    def initialize(input)
      super(input)

      raise ArgumentError, "Vin must be 17 characters long" if input[:vin].length != 17

      @vin = input[:vin]

    end

  end
end
