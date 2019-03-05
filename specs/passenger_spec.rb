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
    trip = RideShare::Trip.new(
      id: 8,
      driver_id: 4,
      passenger: @passenger,
      start_time: "2016-08-08T12:14:00+00:00",
      end_time: "2016-08-08T12:34:00+00:00", # 20 minutes
      cost: 12.18,
      rating: 5,
    )
    @passenger.add_trip(trip)
    trip2 = RideShare::Trip.new(
      id: 10,
      driver_id: 5,
      passenger: @passenger,
      start_time: "2016-08-10T10:35:01+00:00",
      end_time: "2016-08-10T11:00:02+00:00", # 25 minutes, 1 second
      cost: 24.99,
      rating: 5,
    )
    @passenger.add_trip(trip2)
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

  describe "passenger total time" do
    it "returns the total time spent in trips" do
      expect(@passenger.total_time_spent).must_equal 2701
    end
  end

  describe "net_expenditures" do
    it "returns the total passenger costs for all trips" do
      expect(@passenger.net_expenditures).must_equal 37.17
    end
  end
end
