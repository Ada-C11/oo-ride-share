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
                                      name: "Valentine",
                                      vin: "DF5S6HFG365HGDCVG",
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

    it "stores an instance of driver" do
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error if end time is before start time" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      bad_end_time = start_time - 25 * 60 #25 min before start time! AAAAAHHHHH
      expect {
        RideShare::Trip.new(id: 8,
                            passenger: RideShare::Passenger.new(id: 1,
                                                                name: "Ada",
                                                                phone_number: "412-432-7640"),
                            driver_id: 1,
                            start_time: start_time.to_s,
                            end_time: bad_end_time.to_s,
                            cost: 23.45,
                            rating: 3)
      }.must_raise ArgumentError
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

  describe "calculates duration" do
    before do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        driver_id: 1,
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }
      @trip = RideShare::Trip.new(@trip_data)
    end

    it "calculates correct duration" do
      expect(@trip.calculate_duration).must_equal 25 * 60
    end
  end
end
