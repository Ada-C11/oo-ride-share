require_relative "spec_helper"

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
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        driver_id: 2,
        driver: "George",
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

  describe "Net Expenditures Method" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      @trip_one = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        cost: 20,
        rating: 5,
        driver_id: 2,
        driver: "George",
      )
      @trip_two = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        start_time: "2016-10-10",
        end_time: "2016-10-11",
        cost: 30,
        rating: 5,
        driver_id: 2,
        driver: "George",
      )
    end

    it "Totals all trip costs for a passenger" do
      @passenger.add_trip(@trip_one)
      @passenger.add_trip(@trip_two)

      expect(@passenger.net_expenditures).must_equal 50
    end
    it "Returns 0 if the passenger has no trips" do
      expect(@passenger.net_expenditures).must_equal 0
    end
  end

  describe "Total time traveled" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      @trip_one = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2018-12-27 02:39:05 -0800",
        end_time: "2018-12-27 03:38:08 -0800",
        cost: 20,
        rating: 5,
        driver_id: 2,
        driver: "George",
      )
      @trip_two = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        start_time: "2018-12-17 16:09:21 -0800",
        end_time: "2018-12-17 16:42:21 -0800",
        cost: 30,
        rating: 5,
        driver_id: 2,
        driver: "George",
      )
    end
    it "Totals time spent on all rides" do
      @passenger.add_trip(@trip_one)
      @passenger.add_trip(@trip_two)

      expect(@passenger.total_time_spent).must_be_close_to 5523
    end

    it "Returns 0 if trips is nil" do
      expect(@passenger.total_time_spent).must_equal 0
    end
  end
end
