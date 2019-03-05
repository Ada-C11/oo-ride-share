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

    it "raises ArgumentError if end time is before start time" do
      # start_time = Time.parse("2015-05-20T12:14:00+00:00")
      # end_time = start_time - 25 * 60 # 25 minutes

      # puts @trip.start_time

      # total_trip_time = end_time - start_time
      # expect (total_trip_time).must_raise ArgumentError

      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = Time.parse("2010-05-20T12:14:00+00:00") #start_time - 25 * 60 # 25 minutes
      @bad_trip_data = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }
      # @bad_trip = RideShare::Trip.new(@bad_trip_data)

      expect {
        RideShare::Trip.new(@bad_trip_data)
      }.must_raise ArgumentError
      # expect(RideShare::Trip.new(@trip_data)).must_raise ArgumentError
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
  end
  # this is outside "initialize" class!!!
  describe "duration_in_seconds" do
    it "calculates duration of trip in seconds" do
      # Arrange
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes

      trip_with_duration_of_1500 = RideShare::Trip.new({
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      })

      # Act
      trip = trip_with_duration_of_1500.duration_in_seconds

      # Assert
      # expect ___whatever our ACT returns___ .must_equal ___whatever our hard-coded answer is___
      expect (trip).must_equal 1500
    end
  end
end
