require_relative "spec_helper"
require "pry"

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 6,
          name: "Bob",
          vin: "12345678912345678",
          status: :AVAILABLE,
        ),
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

    it "raise an ArgumentError if end time is before start time" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time - 25 * 60 # 25 minutes
      trip_data_2 = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 6,
          name: "Bob",
          vin: "12345678912345678",
          status: :AVAILABLE,
        ),
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }

      expect {
        RideShare::Trip.new(trip_data_2)
      }.must_raise ArgumentError
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

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect do
          RideShare::Trip.new(@trip_data)
        end.must_raise ArgumentError
      end
    end
  end

  describe "trip_duration" do
    it "calculates the duration of a trip in seconds" do
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 6,
          name: "Bob",
          vin: "12345678912345678",
          status: :AVAILABLE,
        ),
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }
      @trip = RideShare::Trip.new(@trip_data)
      result = @trip.trip_duration_seconds
      expect(result).must_equal 1500
    end

    it "calculates the duration of a trip that starts before midnight and ends after midnight" do
      start_time = Time.parse("2015-05-20T23:54:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 6,
          name: "Bob",
          vin: "12345678912345678",
          status: :AVAILABLE,
        ),
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }

      @trip = RideShare::Trip.new(@trip_data)
      result = @trip.trip_duration_seconds
      expect(result).must_equal 1500
    end

    it "returns a value of 0 if start and end time are the same" do
      start_time = Time.parse("2015-05-20T23:54:00+00:00")
      end_time = start_time
      @trip_data = {
        id: 8,
        driver: RideShare::Driver.new(
          id: 6,
          name: "Bob",
          vin: "12345678912345678",
          status: :AVAILABLE,
        ),
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
      }

      @trip = RideShare::Trip.new(@trip_data)
      result = @trip.trip_duration_seconds
      expect(result).must_equal 0
    end
  end
end
