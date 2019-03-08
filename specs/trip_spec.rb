require_relative "spec_helper"

describe "Trip class" do
  describe "initialize" do
    before do
      @duration = 25 * 60 # 25 minutes
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + @duration
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
        driver_id: 3,
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "raises an error if start time is after end time" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time - @duration
      @trip_data[:start_time] = start_time.to_s
      @trip_data[:end_time] = end_time.to_s
      expect do
        RideShare::Trip.new(@trip_data)
      end.must_raise ArgumentError
    end

    it "calculates trip duration" do
      expect(@trip.calculate_trip_time).must_equal @duration
    end

    it "returns 0 as duration for trip in progress" do
      trip = RideShare::Trip.new(
        id: 8,
        driver_id: 3,
        passenger_id: 3,
        start_time: "2016-08-08",
        end_time: nil,
        rating: nil,
        cost: nil,
      )
      expect(trip.calculate_trip_time).must_equal 0
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      expect(@trip.driver).must_be_kind_of RideShare::Driver if @trip.driver
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
end
