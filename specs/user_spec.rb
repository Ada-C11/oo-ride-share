require_relative 'spec_helper'

describe "User class" do

  describe "User instantiation" do
    before do
      @user = RideShare::User.new({id: 1, name: "Smithy", phone: "353-533-5334"})
    end

    it "is an instance of User" do
      expect(@user).must_be_kind_of RideShare::User
    end

    it "throws an argument error with a bad ID value" do
      expect{ RideShare::User.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@user.trips).must_be_kind_of Array
      expect(@user.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@user).must_respond_to prop
      end

      expect(@user.id).must_be_kind_of Integer
      expect(@user.name).must_be_kind_of String
      expect(@user.phone_number).must_be_kind_of String
      expect(@user.trips).must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      @user = RideShare::User.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 rating: 5)

      @user.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @user.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's user id" do
      @user.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end

  # Initial Tests for Wave 2
  # describe "get_drivers method" do
  #   before do
  #     @user = RideShare::User.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
  #     driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
  #     trip = RideShare::Trip.new({id: 8, driver: driver, user: @user, date: "2016-08-08", rating: 5})
  #
  #     @user.add_trip(trip)
  #   end
  #
  #   it "returns an array" do
  #     skip # Unskip after wave 2
  #
  #     drivers = @user.get_drivers
  #     expect(drivers).must_be_kind_of Array
  #     expect(drivers.length).must_equal 1
  #   end
  #
  #   it "all items in array are Driver instances" do
  #     skip # Unskip after wave 2
  #
  #     @user.get_drivers.each do |driver|
  #       expect(driver).must_be_kind_of RideShare::Driver
  #     end
  #   end
  # end
end
