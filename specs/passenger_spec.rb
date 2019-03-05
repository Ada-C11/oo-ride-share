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

  describe "trips properly" do
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
        start_time: "2018-08-05 09:00:00 -07008",
        end_time: "2018-08-05 09:30:00 -0700",
        cost: 23.45,
        rating: 5,
      )
      trip2 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2018-05-25 11:50:00 -0700",
        end_time: "2018-05-25 12:25:00 -0700",
        cost: 35.67,
        rating: 5,
      )

      @passenger_two = RideShare::Passenger.new(
        id: 9,
        name: "Mudkip",
        phone_number: "1-602-620-3346 x3723",
        trips: [],
      )
      @passenger.add_trip(trip2)
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
    it "Returns the correct total amount that customer has spent" do

      # total_paid = @passenger.trips.sum { |trip| trip.cost }
      expect(@passenger.net_expenditures).must_equal 59.12
      expect(@passenger_two.net_expenditures).must_equal 0
    end

    it "Returns the total amount of time the passenger has spent on trips" do
      expect(@passenger_two.total_time_spent).must_equal 0
      expect(@passenger.total_time_spent).must_equal 3900
    end
  end
end
