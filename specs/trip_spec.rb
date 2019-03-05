require_relative "spec_helper"

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = "2015-05-20T12:14:00+00:00"
      end_time = "2018-05-25 12:25:00 -0700"
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3, driver: RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE,
        ),
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      skip # Unskip after wave 2
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

    it "converts start and end time string to objects" do
      expect(@trip.start_time).must_be_kind_of Time
      expect(@trip.end_time).must_be_kind_of Time
    end

    it "raises if end time is earlier than start time" do
      start_time = "2015-05-20T12:14:00+00:00"
      end_time = "2013-05-25 12:25:00 -0700"
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3, driver: RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE,
        ),
      }

      expect do
        RideShare::Trip.new(@trip_data).must_raise ArgumentError
      end
    end

    it "returns duration between trip start and end" do
      start_time = "2018-05-25 11:00:00 -0700"
      end_time = "2018-05-25 12:00:00 -0700"
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3, driver: RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE,
        ),
      }

      trip = RideShare::Trip.new(@trip_data)
      expect(trip.trip_duration).must_equal 3600
    end
  end
end
