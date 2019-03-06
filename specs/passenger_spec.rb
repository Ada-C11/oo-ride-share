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
        id: 1,
        name: "Paul Klee",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE,
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        driver: @driver,
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

  describe "#net_expenditure" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      @driver = RideShare::Driver.new(
        id: 1,
        name: "Paul Klee",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE,
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        cost: 110,
        driver: @driver,
      )
      @passenger.add_trip(trip)
      trip = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        cost: 230,
        driver: @driver,
      )

      @passenger.add_trip(trip)
    end
    it "returns the correct total cost" do
      expect(@passenger.net_expenditures(9)).must_equal 340
      expect { (@passenger.net_expenditures(10)) }.must_raise ArgumentError
    end
  end

  describe "#total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      @driver = RideShare::Driver.new(
        id: 1,
        name: "Paul Klee",
        vin: "WBS76FYD47DJF7206",
        status: :AVAILABLE,
      )

      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2019-01-09 21:16:51 -0800",
        end_time: "2019-01-09 22:14:39 -0800",
        rating: 5,
        cost: 110,
        driver: @driver,
      )
      @passenger.add_trip(trip)
      trip = RideShare::Trip.new(
        id: 9,
        passenger: @passenger,
        start_time: "2019-01-25 11:05:28 -0800",
        end_time: "2019-01-25 11:35:35 -0800",
        rating: 5,
        cost: 230,
        driver: @driver,
      )

      @passenger.add_trip(trip)
    end

    it "returns correct time spent" do
      time_duration1 = Time.parse("2019-01-09 22:14:39 -0800") - Time.parse("2019-01-09 21:16:51 -0800")
      time_duration2 = Time.parse("2019-01-25 11:35:35 -0800") - Time.parse("2019-01-25 11:05:28 -0800")
      total_duration_trips = time_duration1 + time_duration2
      expect(@passenger.total_time_spent(9)).must_equal total_duration_trips
      expect { (@passenger.total_time_spent(10)) }.must_raise ArgumentError
    end
  end
end
