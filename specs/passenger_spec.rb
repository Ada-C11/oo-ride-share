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

      @driver = RideShare::Driver.new(
        id: 6,
        name: "Bob",
        vin: "12345678912345678",
        status: :AVAILABLE,
      )

      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
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

  describe "net_expenditures method" do
    it "calculates a passenger's trip costs" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )

      @driver = RideShare::Driver.new(
        id: 6,
        name: "Bob",
        vin: "12345678912345678",
        status: :AVAILABLE,
      )

      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        cost: 5.50,
        rating: 5,
      )

      @passenger.add_trip(trip)

      trip = RideShare::Trip.new(
        id: 10,
        driver: @driver,
        passenger: @passenger,
        start_time: "2016-08-10",
        end_time: "2016-08-11",
        cost: 10.0,
        rating: 5,
      )
      @passenger.add_trip(trip)

      result = @passenger.net_expenditures
      expect(result).must_equal 15.50
    end

    it "doesn't include the cost of an in-progress trip for a passenger" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )

      @driver = RideShare::Driver.new(
        id: 6,
        name: "Bob",
        vin: "12345678912345678",
        status: :AVAILABLE,
      )

      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        cost: 5.50,
        rating: 5,
      )

      @passenger.add_trip(trip)

      trip = RideShare::Trip.new(
        id: 10,
        driver: @driver,
        passenger: @passenger,
        start_time: "2016-08-10",
        end_time: nil,
        cost: nil,
        rating: nil,
      )
      @passenger.add_trip(trip)

      result = @passenger.net_expenditures
      expect(result).must_equal 5.50
    end

    it "returns 0 if the passenger hasn't taken any trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )

      result = @passenger.net_expenditures
      expect(result).must_equal 0
    end
  end

  describe "total_time_spent method" do
    it "calculates the total amount of time a passenger has spent on their trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )

      @driver = RideShare::Driver.new(
        id: 6,
        name: "Bob",
        vin: "12345678912345678",
        status: :AVAILABLE,
      )

      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        cost: 5.50,
        rating: 5,
      )

      @passenger.add_trip(trip)

      trip = RideShare::Trip.new(
        id: 10,
        driver: @driver,
        passenger: @passenger,
        start_time: "2016-08-10",
        end_time: "2016-08-11",
        cost: 10.0,
        rating: 5,
      )
      @passenger.add_trip(trip)

      duration = @passenger.total_time_spent
      expect(duration).must_equal 172800
    end

    it "returns 0 if a passenger has not taken any trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )

      duration = @passenger.total_time_spent
      expect(duration).must_equal 0
    end
  end
end
