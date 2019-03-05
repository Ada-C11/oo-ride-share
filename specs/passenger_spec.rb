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
<<<<<<< HEAD
        rating: 5,
      )
=======
        cost: 20,
        rating: 5
        )
>>>>>>> c9127b2e62c663b3ee002be394640d737791c61c

      trip2 = RideShare::Trip.new(
          id: 8,
          passenger: @passenger,
          start_time: "2016-08-10",
          end_time: "2016-08-11",
          cost: 20,
          rating: 5
        )
      @passenger.add_trip(trip)
      @passenger.add_trip(trip2)
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

    it "totals up Passenger's trips" do
      total_trip = @passenger.net_expenditures
      expect(total_trip).must_equal 40
    end

    # it "returns zero for net_expenditure if passenger has no trips" do
    #   total_trip = nil
    #   total_trip = @passenger.net_expenditures

    #   expect(total_trip).must_equal 0
    # end
  end

  describe "total time spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Bob Smith",
        phone_number: "1-206-620-2330",
        trips: [],
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
      )
      trip2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: "2016-08-10",
        end_time: "2016-08-11",
        rating: 5,
      )
      @passenger.add_trip(trip)
      @passenger.add_trip(trip2)
    end

    it "total amount of time passenger has spent on trips" do
      expect(@passenger.total_time_spent).must_equal 172800
    end
  end
end
