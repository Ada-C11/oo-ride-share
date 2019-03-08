require_relative "spec_helper"

describe "Trip class" do
  before do
    start_time = Time.parse("2015-05-20T12:14:00+00:00")
    end_time = start_time + 25 * 60 # 25 minutes
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
      driver: RideShare::Driver.new(id: 54,
                                    name: "Rogers Bartell IV",
                                    vin: "1C9EVBRM0YBC564DZ"),
    }
    @trip = RideShare::Trip.new(@trip_data)
  end
  describe "initialize" do
    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      # Unskip after wave 2
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

    it "raise Argument Error if end_time is before start_time" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time - 25 * 60 # 25 minutes
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

      expect { RideShare::Trip.new(@trip_data) }.must_raise ArgumentError
    end

    describe "Wave 1: Update time" do
      it "start_time should be of Time class" do
        expect(@trip.start_time).must_be_instance_of Time
      end

      it "end_time should be of Time class" do
        expect(@trip.end_time).must_be_instance_of Time
      end

      it "confirms time is correctly parsed" do
        expect(@trip.start_time).must_equal Time.new(2015, 5, 20, 12, 14, 00, 00)
      end
    end
  end

  describe "Trip#duration" do
    it "returns a integer" do
      expect(@trip.duration).must_be_instance_of Integer
    end

    it "NOMINAL: returns seconds same day" do
      expect(@trip.duration).must_equal 1500
    end

    it "EDGE: calculates correct seconds over crossing more than one day" do
      start_time = Time.parse("2015-05-20T23:50:00+00:00")
      end_time = Time.parse("2015-05-21T00:10:00+00:00")
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
      trip_over_midnight = RideShare::Trip.new(@trip_data)
      expect(trip_over_midnight.duration).must_equal 1200
    end

    it "EDGE: if times are equal return 0" do
      start_time = Time.parse("2015-05-20T23:50:00+00:00")
      end_time = start_time
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
      trip_time_equal = RideShare::Trip.new(@trip_data)
      expect(trip_time_equal.duration).must_equal 0
    end

    it "will raise an execption when calculating duration of inprogress trip" do
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: Time.new().to_s,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver_id: 3,
      }
      expect(RideShare::Trip.new(@trip_data).duration).must_be_nil
    end
  end
end
