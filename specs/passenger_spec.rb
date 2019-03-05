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
        driver: 1,
        id: 8,
        passenger: @passenger,
        start_time: "2015-05-20T12:14:00+00:00",
        end_time: "2015-05-20T12:25:00+00:00",
        rating: 5,
        cost: 25,
      )
      trip_2 = RideShare::Trip.new(
        driver: 3,
        id: 10,
        passenger: @passenger,
        start_time: "2016-05-20T13:14:00+00:00",
        end_time: "2016-05-20T14:14:00+00:00",
        rating: 5,
        cost: 45,
      )

      @passenger.add_trip(trip)
      @passenger.add_trip(trip_2)

      @passenger_2 = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
    end

    it "calculates total cost of all trips" do
      total = @passenger.net_expenditures

      expect(total).must_equal 70
    end

    it "calculates total time spent on all trips" do
      total = @passenger.total_time_spent

      expect(total).must_equal 4260.0
    end

    it "returns 0 if the passenger has no trips" do
      total = @passenger_2.total_time_spent
      expect(total).must_equal 0
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
end
