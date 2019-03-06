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
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        cost: 9,
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

    it "net_expenditures returns the correct cost" do
      expect(@passenger.net_expenditures).must_equal 9
    end

    it "total_time_spent returns sum of durations" do
      expect(@passenger.total_time_spent).must_equal 1440
    end
  end

  describe "in progress trips" do
    before do
      @pass = RideShare::Passenger.new(
        id: 1,
        name: "Test Passenger",
        phone_number: "412-432-7640",
      )
      @driver = RideShare::Driver.new(
        id: 3,
        name: "Test Driver",
        vin: "12345678912345678",
      )
      @trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @pass,
        start_time: "2016-08-08",
        end_time: "2018-08-09",
        rating: 5,
        cost: 6.65,
      )

      @trip2 = RideShare::Trip.new(
        id: 2,
        driver: @driver,
        passenger: @pass,
        start_time: "2016-08-08",
        end_time: nil,
        rating: nil,
        cost: nil,
      )
      @driver.add_trip(@trip)
    end

    it "calcluates total expenditures during in progress trip" do
      initial_expediture = @pass.net_expenditures
      @pass.add_trip(@trip2)
      second_expenditure = @pass.net_expenditures

      expect(initial_expediture).must_equal second_expenditure
    end
  end
end
