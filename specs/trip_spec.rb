require_relative "spec_helper"

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        driver: RideShare::Driver.new(id: 1,
                                      name: "Bob",
                                      vin: "ABCDEFGHIJKLMNOPQ",
                                      status: :AVAILABLE),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of time" do
      expect(@trip.start_time).must_be_instance_of Time
      expect(@trip.end_time).must_be_instance_of Time
    end

    it "raises an error if end time is greater than start time" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time - 15 * 60 # 15 minutes
      @trip_data[:start_time] = start_time.to_s
      @trip_data[:end_time] = end_time.to_s

      expect do
        @trip = RideShare::Trip.new(@trip_data)
      end.must_raise ArgumentError
    end

    it "stores an instance of driver" do
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end
  end

  describe "class method trip_duration" do
    before do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        driver: RideShare::Driver.new(id: 1,
                                      name: "Bob",
                                      vin: "ABCDEFGHIJKLMNOPQ",
                                      status: :AVAILABLE),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "returns the trip duration in seconds" do
      expect(@trip.trip_duration).must_equal 1500
    end
  end

  describe "no end time case" do
    before do
      start_time = Time.parse("#{Time.now}")
      end_time = nil
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        driver: RideShare::Driver.new(id: 1,
                                      name: "Bob",
                                      vin: "ABCDEFGHIJKLMNOPQ",
                                      status: :AVAILABLE),
        start_time: start_time.to_s,
        end_time: nil,
        cost: nil,
        rating: 3,
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "does not calculate trip duration for nil end time" do
      assert_nil(@trip.trip_duration)
    end
  end
end
