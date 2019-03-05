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

  describe "net_expenditures" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        cost: 10,
        rating: 5,
      )
      trip2 = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: "2016-08-10",
        end_time: "2016-08-11",
        cost: 15,
        rating: 4,
      )

      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
    end

    it "each passengers total trip costs" do
      expect(@passenger.net_expenditures).must_equal 25
    end

    describe "total_time_spent" do
      before do
        @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III",
                                              phone_number: "1-602-620-2330 x3723", trips: [])

        trip = RideShare::Trip.new({id: 8, passenger: @passenger,
                                    start_time: "2018-05-25",
                                    end_time: "2018-05-25",
                                    rating: 5, cost: 10.11})

        @passenger.add_trip(trip)

        trip = RideShare::Trip.new({id: 8, passenger: @passenger,
                                    start_time: "2018-07-23",
                                    end_time: "2018-07-23",
                                    rating: 4, cost: 20})

        @passenger.add_trip(trip)
        # @edge_passenger = RideShare::Passenger.new(id: 10, name: "Mike Smith",
        #                                            phone_number: "1-602-620-2335 x3720", trips: [])
      end

      it "total amount of time each passenger has spent on trips" do
        expect(@passenger.total_time_spent).must_equal 7080.0
        expect(@passenger.total_time_spent).must_be_instance_of Float
      end
    end
  end
end
