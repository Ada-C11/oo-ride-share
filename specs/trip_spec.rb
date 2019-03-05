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
      skip # Unskip after wave 2
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid end time" do
      start_time = Time.parse("2019-01-09 08:48:50 -0800")
      end_time = Time.parse("2019-01-09 07:48:50 -0800")

      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }
      # @trip = RideShare::Trip.new(@trip_data)

      expect {
        RideShare::Trip.new(@trip_data)
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

  describe "Duration calculator" do
    before do
      start_time = Time.parse("2018-12-17 16:09:21 -0800")
      # , Time.parse("2019-01-24 21:36:19 -0800"), Time.parse("2018-12-30 10:38:40 -0800")]
      end_time = Time.parse("2018-12-17 16:42:21 -0800")
      # , Time.parse("2019-01-24 22:21:36 -0800"), Times.parse("2018-12-30 11:36:12 -0800")]
      duration_in_seconds = 1980
      # , 2700, 3480]

      @trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }

      @test_ride = RideShare::Trip.new(@trip_data)
    end

    it "Calculates the trip duration in seconds" do
      # start_times.each_with_index do |start_time, i|
      expect(@test_ride.duration).must_be_close_to 1980
      # end
    end
  end
end
