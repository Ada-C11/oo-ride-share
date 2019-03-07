require_relative 'spec_helper'

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
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      @driver = RideShare::Driver.new(
        id: 1,
        name: "Karl",
        vin: "ABCDEFGHIJKLMNOPQ",
        status: :UNAVAILABLE,
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5
        )

      @passenger.add_trip(trip)
      @driver.add_trip(trip)
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

  describe "method net_expenditure" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Wendy Leonelli",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      @driver = RideShare::Driver.new(
        id: 1,
        name: "Karl",
        vin: "ABCDEFGHIJKLMNOPQ",
        status: :UNAVAILABLE,
        trips: []
      )
      trip_one = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        cost: 20,
        rating: 5
        )
      trip_two = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        driver: @driver,
        start_time: "2016-09-09",
        end_time: "2016-09-10",
        cost: 40,
        rating: 4
      )

      @passenger.add_trip(trip_one)
      @passenger.add_trip(trip_two)
      @driver.add_trip(trip_one)
      @driver.add_trip(trip_two)
    end
    it "returns total costs of a passenger's trips" do
      expect(@passenger.net_expenditures).must_equal 60
    end
  end

  describe "method total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Jack Unbehend",
        phone_number: "1-206-735-2910 x345",
        trips: []
        )

      @driver = RideShare::Driver.new(
        id: 1,
        name: "Karl",
        vin: "ABCDEFGHIJKLMNOPQ",
        status: :UNAVAILABLE,
        trips: []
      )
      
      trip_one = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: (Time.parse('2015-05-20T12:14:00+00:00')).to_s,
        end_time: (Time.parse('2015-05-20T12:14:00+00:00') + 20 * 60).to_s,
        cost: 20,
        rating: 5
        )
      trip_two = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        driver: @driver,
        start_time: (Time.parse('2016-05-20T12:14:00+00:00')).to_s,
        end_time: (Time.parse('2016-05-20T12:14:00+00:00') + 30 * 60).to_s,
        cost: 40,
        rating: 4
      )

      @passenger.add_trip(trip_one)
      @passenger.add_trip(trip_two)
      @driver.add_trip(trip_one)
      @driver.add_trip(trip_two)
    end

    it "returns total time spent on all trips" do
      expect(@passenger.total_time_spent).must_equal 3000
    end
  end
end
