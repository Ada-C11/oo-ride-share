require_relative 'spec_helper'

describe "Trip class" do
  before do
    start_time = Time.parse('2015-05-20T12:14:00+00:00')
    end_time = start_time + 25 * 60 # 25 minutes
    @trip_data = {
      id: 8,
      passenger: RideShare::User.new(id: 1,
                                     name: "Ada",
                                     phone: "412-432-7640"),
      driver: RideShare::Driver.new(id: 2,
                                    name: 'AdaDriver',
                                    phone: '111-111-1111',
                                    vin: "1" * 17,
                                    status: :UNAVAILABLE),
      start_time: start_time,
      end_time: end_time,
      cost: 23.45,
      rating: 3
    }
    @trip = RideShare::Trip.new(@trip_data)
  end

  describe "initialize" do

    it "is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "stores an instance of user" do
      expect(@trip.passenger).must_be_kind_of RideShare::User
    end

    it "stores an instance of driver" do
      #skip  # Unskip after wave 2
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end

    it "raises an error for an invalid rating" do
      [-3, 0, 6].each do |rating|
        @trip_data[:rating] = rating
        expect {
          RideShare::Trip.new(@trip_data)
        }.must_raise ArgumentError
      end
    end

    it "raises an error for invalid start_time and end_time" do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60 # 25 minutes
      trip_data = {
        id: 8,
        passenger: RideShare::User.new(id: 1,
                                       name: "Ada",
                                       phone: "412-432-7640"),
        driver: RideShare::Driver.new(id: 2,
                                      name: 'AdaDriver',
                                      phone: '111-111-1111',
                                      vin: "1" * 17,
                                      status: :UNAVAILABLE),
        start_time: end_time,
        end_time: start_time,
        cost: 23.45,
        rating: 3
      }
      expect {
        RideShare::Trip.new(trip_data)
      }.must_raise ArgumentError

    end


  end

  it "can calculate the trip duration" do
    expect(@trip.duration).must_equal 25 * 60
  end
end
