
module RideShare
  class Trip
    attr_reader :id, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end
      [@start_time, @end_time].each do |time|
        [:-, :to_i].each do |method|
          raise ArgumentError, "Times must be subtractable and convertable to integers" unless time.respond_to? method
        end
      end
    end

    def duration
      return end_time - start_time
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end
  end
end
