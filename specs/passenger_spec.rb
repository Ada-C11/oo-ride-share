require_relative "spec_helper"
require "time"

describe "Passenger class" do
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end

    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end

      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end

  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )

      @driver = RideShare::Driver.new(
        id: 12,
        name: "Paul Klee",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE, 
        trips: [],
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
      )

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end

  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )

      @driver = RideShare::Driver.new(
        id: 12,
        name: "Paul Klee",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE, 
        trips: [],
      )

      start_time = Time.parse("2015-05-20T11:14:00+00:00")
      end_time = Time.parse("2015-05-20T12:14:00+00:00")

      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 45.20,
        rating: 5,
      )

      start_time2 = Time.parse("2015-05-21T12:14:00+00:00")
      end_time2 = Time.parse("2015-05-21T12:19:00+00:00")

      trip2 = RideShare::Trip.new(
        id: 45,
        passenger: @passenger,
        driver: @driver,
        start_time: start_time2.to_s,
        end_time: end_time2.to_s,
        cost: 23.56,
        rating: 3,
      )

      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
    end

    it "returns the total amount of money that passenger has spent on their trips" do
      expect(@passenger.net_expenditures).must_equal 68.76
    end

    it "returns the total amount of time the passenger has spent on their trips" do
      expect(@passenger.total_time_spent).must_equal 3900
    end
  end
end
