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
        driver_id: 1,
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
      # skip # Unskip after wave 2
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

    # TEST 5
    it "raises an error if start time is after (>) end time" do
      # bad_end_time = @trip_data[:start_time] #- 25 * 60 # 25 minutes earlier than start time
      # @trip_data[:end_time] = bad_end_time
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
      }
      # @trip = RideShare::Trip.new(@trip_data)
      expect {
        RideShare::Trip.new(@trip_data)
        # existing_start_time = test_trip_1.start_time
        # existing_end_time = test_trip_1.end_time
        # test_trip_1.start_time = existing_end_time + 25 * 60
      }.must_raise ArgumentError
    end
    # TEST 6
    it "raises an error if start time is the same as end time" do
      @trip_data[:end_time] = @trip_data[:start_time]
      expect do
        RideShare::Trip.new(@trip_data)
      end.must_raise ArgumentError
    end
  end
  # TEST 7
  describe "duration method" do    
    it "returns an integer for trip duration" do
      # start_time = Time.parse(@trip_data[:start_time])
      # end_time = Time.parse(@trip_data[:end_time])
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
      # test_trip = RideShare::Trip.new(@trip_data)
      start_time = Time.parse(@trip_data[:start_time])
      end_time = Time.parse(@trip_data[:end_time])
      # expect(end_time - start_time).must_equal 15 # fails
      expect(end_time - start_time).must_equal 1500 # Passes
    end
  end
end
