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

  before do
    # TODO: you'll need to add a driver at some point here.
    @passenger = RideShare::Passenger.new(
      id: 9,
      name: "Merl Glover III",
      phone_number: "1-602-620-2330 x3723",
      trips: [],
    )

    start_time = Time.parse("2015-05-20T12:14:00+00:00")
    end_time = start_time + 25 * 60 # 25 minutes

    trip = RideShare::Trip.new(
      id: 8,
      cost: 30,
      passenger: @passenger,
      start_time: start_time.to_s,
      end_time: end_time.to_s,
      rating: 5,
    )

    @passenger.add_trip(trip)

    trip = RideShare::Trip.new(
      id: 8,
      cost: 30,
      passenger: @passenger,
      start_time: start_time.to_s,
      end_time: end_time.to_s,
      rating: 5,
    )

    @passenger.add_trip(trip)

    trip = RideShare::Trip.new(
      id: 8,
      cost: 30,
      passenger: @passenger,
      start_time: start_time.to_s,
      end_time: end_time.to_s,
      rating: 5,
    )

    @passenger.add_trip(trip)
  end

  describe "trips property" do
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

  describe "Wave-1: Test Passenger#net_expenditures method" do
    it "Net-expeditures method should return an integer" do
      expect(@passenger.net_expenditures).must_be_instance_of Integer
    end

    it "Should calculate correct cost of trips" do
      expect(@passenger.net_expenditures).must_equal 90
    end

    it "should return 0 if passenger has no trip" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      expect(@passenger.net_expenditures).must_equal 0
    end
  end
  describe "Wave-1: Test Passenger#total_time_spent method" do
    it "should return interger" do
      expect(@passenger.total_time_spent).must_be_instance_of Integer
    end

    it "Should calculated the correct total time duration of all trips for passenger" do
      expect(@passenger.total_time_spent).must_equal 4500
    end
    it "Should return 0 for passenger with no trip" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      expect(@passenger.total_time_spent).must_equal 0
    end
  end
end
