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
        cost: 10, #added cost
        driver_id: 3,
      ) #created trip_2
      trip_2 = RideShare::Trip.new(
        id: 11,
        passenger: @passenger,
        start_time: "2016-08-22",
        end_time: "2016-08-25",
        rating: 2,
        cost: 15, #added cost
        driver_id: 3,
      )
      @passenger.add_trip(trip)
      @passenger.add_trip(trip_2)

      @net_expenditures = trip.cost + trip_2.cost

      @total_time_spent = trip.calculate_trip_time + trip_2.calculate_trip_time
    end

    # test net_expenditures
    it "will return the total amount of money spent on trips" do
      expect(@passenger.net_expenditures).must_equal @net_expenditures
    end

    # test total_time_spent
    it "will return the total time spent" do
      expect(@passenger.total_time_spent).must_equal @total_time_spent
    end

    it "will return 0 for total expediture and time spent for 0 rides" do
      passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      expect(passenger.net_expenditures).must_equal 0
      expect(passenger.total_time_spent).must_equal 0
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
