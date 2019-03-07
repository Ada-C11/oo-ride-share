require_relative "spec_helper"
require "time"

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60
      @trip_data = {
        driver_id: RideShare::Driver.new(
          id: 54,
          name: "Rogers Bartell IV",
          vin: "1C9EVBRM0YBC564DZ",
        ),
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

    it "raises an ArgumentError if start time is after end time." do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = Time.parse("2014-05-20T12:14:00+00:00")
      @trip_data = {
        driver_id: RideShare::Driver.new(
          id: 54,
          name: "Rogers Bartell IV",
          vin: "1C9EVBRM0YBC564DZ",
        ),
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }
      expect { RideShare::Trip.new(@trip_data) }.must_raise ArgumentError
    end

    it "return trip duration in seconds" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = Time.parse("2015-05-20T12:14:21+00:00")
      @trip_data = {
        driver_id: RideShare::Driver.new(
          id: 54,
          name: "Rogers Bartell IV",
          vin: "1C9EVBRM0YBC564DZ",
        ),
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }
      trip_time = RideShare::Trip.new(@trip_data).trip_duration
      expect(trip_time).must_equal 21
    end

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end

    it "stores an instance of driver" do
      expect(@trip.driver_id).must_be_kind_of RideShare::Driver
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
