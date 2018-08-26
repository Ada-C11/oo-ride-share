require_relative 'spec_helper'

describe "User class" do
  before do
    @user = RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334")
  end

  describe "User instantiation" do
    it "is an instance of User" do
      expect(@user).must_be_kind_of RideShare::User
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::User.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
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
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
                                  phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 cost: 5,
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

    describe "total_expenditures" do

      it "allows us to calculate total expenditures" do
        expect(@user.net_expenditures).must_equal 5

      # Adding another trip
        @user.add_trip(RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                           start_time: Time.parse("2016-08-14"),
                                           end_time: Time.parse("2016-08-15"),
                                           cost: 15,
                                           rating: 1))

        expect(@user.net_expenditures).must_equal 20
      end

      it "also works for users with no trips" do
        new_user = RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334")

        expect(new_user.net_expenditures).must_equal 0
      end

      it "does not count incomplete trips" do
        net_expenditures = @user.net_expenditures
        @user.add_trip(RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                           start_time: Time.parse("2016-08-14")))

        expect(@user.net_expenditures).must_be_close_to net_expenditures, 0.01
      end
    end
  end

  describe "total_time_spent" do
    it "will calculate the total duration of all trips" do
      @user.add_trip(RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                         start_time: Time.parse("2016-08-14"),
                                         end_time: Time.parse("2016-08-15"),
                                         cost: 15,
                                         rating: 1))

      # 1 day = 24 hours which is 60 minutes each of which is 60 sec
      expect(@user.total_time_spent).must_equal 24 * 60 * 60

      @user.add_trip(RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                         start_time: Time.parse("2016-08-14 10:39:59 -0700"),
                                         end_time: Time.parse("2016-08-14 10:59:59 -0700"),
                                         cost: 15,
                                         rating: 1))

      expect(@user.total_time_spent).must_equal 24 * 60 * 60 + 60 * 20
    end

    it "will return 0 for a user without trips" do
      new_user = RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334")
      expect(new_user.total_time_spent).must_equal 0
    end

    it "does not count incomplete trips" do
      total_time = @user.total_time_spent
      @user.add_trip(RideShare::Trip.new(id: 18, driver: nil, passenger: @user,
                                         start_time: Time.parse("2016-08-14 10:39:59 -0700")))
      expect(@user.total_time_spent).must_equal total_time
    end
  end
end
