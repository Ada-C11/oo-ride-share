require_relative 'spec_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 1, 
        name: "Smithy", 
        phone_number: "353-533-5334"
      )
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
        id: 80,
        name: "Amy",
        vin: "12345678901234567",
        status: :AVAILABLE,
        trips: []
      )
      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: "2016-08-09 00:03:00",
        end_time: "2016-08-09 00:03:36",
        rating: 5,
        cost: 20,
        driver_id: 80
      )
      trip2 = RideShare::Trip.new(
        id: 10,
        passenger: @passenger,
        start_time: "2016-08-09 00:03:05",
        end_time: "2016-08-09 00:03:55",
        rating: 5,
        cost: 30,
        driver_id: 89
      )
      @passenger.add_trip(trip2)
      @passenger.add_trip(trip1)
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

    it "returns the total amount spent by passenger" do
      expect(@passenger.net_expenditures).must_equal 50
    end

    it "raises an error when the passenger has no trips" do
      @passenger = RideShare::Passenger.new(
        id: 20,
        name: "Merl Glover",
        phone_number: "1-602-620-2330 x3733",
        trips: nil
      )
      expect{(@passenger.net_expenditures)}.must_raise ArgumentError
      expect{(@passenger.total_time_spent)}.must_raise ArgumentError  
    end
    
    it "calculates total time spent per passenger" do
      expect(@passenger.total_time_spent).must_equal "86.0 minutes"
    end
  end
end
