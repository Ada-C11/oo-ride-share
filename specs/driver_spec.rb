require_relative 'spec_helper'
require 'pry'

describe "Driver class" do
  before do
    @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
      vin: "1C9EVBRM0YBC564DZ",
      phone: '111-111-1111',
      status: :AVAILABLE)

    end

    describe "Driver instantiation" do

      it "is an instance of Driver" do
        expect(@driver).must_be_kind_of RideShare::Driver
      end

      it "is an instance of User" do
        expect(@driver).must_be_kind_of RideShare::User
      end

      it "throws an argument error with a bad ID value" do
        expect{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
      end

      it "throws an argument error with a bad VIN value" do
        expect{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
        expect{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
      end

      it "sets trips to an empty array if not provided" do
        expect(@driver.driven_trips).must_be_kind_of Array
        expect(@driver.driven_trips.length).must_equal 0
      end

      it "is set up for specific attributes and data types" do
        [:id, :name, :vehicle_id, :status].each do |prop|
          expect(@driver).must_respond_to prop
        end

        expect(@driver.id).must_be_kind_of Integer
        expect(@driver.name).must_be_kind_of String
        expect(@driver.vehicle_id).must_be_kind_of String
        expect(@driver.status).must_be_kind_of Symbol
      end
    end

    describe "add drive method" do
      before do
        pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
        @trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: pass, start_time: Time.parse("2016-08-08"), rating: 5)
      end

      it "throws an argument error if trip is not provided" do
        expect{ @driver.add_driven_trip(1) }.must_raise ArgumentError
      end

      it "increases the trip count by one" do
        previous = @driver.trips.length
        @driver.add_trip(@trip)
        expect(@driver.trips.length).must_equal previous + 1
      end
    end

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                    vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                               date: Time.parse("2016-08-08"), rating: 5)
      @driver.add_trip(trip)
    end

    it "returns a float" do
      expect(@driver.average_rating).must_be_kind_of Float
    end




  describe "total_revenue" do
    before do
      trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: nil,
                                     start_time: Time.parse("2016-08-08"),
                                     end_time: Time.parse('2016-08-09'),
                                     rating: 5, cost: 5)
      @driver.add_driven_trip(trip)
    end

    it "returns a float" do
      expect(@driver.total_revenue).must_be_kind_of Float
    end

    it "returns 0 if there are no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      expect(driver.total_revenue).must_equal 0
    end

    it "calculates total revenue correctly" do
      expect(@driver.total_revenue).must_be_close_to (5 - 1.65) * 0.8, 0.01

      @driver.add_driven_trip(RideShare::Trip.new(id: 47, driver: @driver, passenger: nil,
                                                  start_time: Time.parse('2016-08-08'),
                                                  end_time: Time.parse('2016-08-09'),
                                                  rating: 5, cost: 15))

      expect(@driver.total_revenue).must_be_close_to (5 - 1.65 + 15 - 1.65) * 0.8, 0.01
    end

    it "does not include incomplete trips" do
      trip = RideShare::Trip.new(id: 14, driver: @driver, passenger: nil,
        start_time: Time.parse("2016-08-08"))

      total_revenue = @driver.total_revenue

      @driver.add_driven_trip(trip)
      expect(@driver.total_revenue).must_be_close_to total_revenue, 0.01
    end
  end

  describe "net_expenditures" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                      vin: "1C9EVBRM0YBC564DZ",
                                      phone: '111-111-1111',
                                      status: :AVAILABLE)

      passenger_trip = RideShare::Trip.new(id: 8, driver: nil, passenger: @driver,
                                           start_time: Time.parse("2016-08-08"),
                                           rating: 5, cost: 5)

      driven_trip = RideShare::Trip.new(id: 3, driver: @driver, passenger: nil,
                                        start_time: Time.parse("2016-08-09"),
                                        end_time: Time.parse("2016-08-10"),
                                        rating: 3, cost: 15)

      @driver.add_trip(passenger_trip)
      @driver.add_driven_trip(driven_trip)
    end

    it "calculates the proper net expenditures" do
      expect(@driver.net_expenditures).must_be_close_to 5 - (15 - 1.65) * 0.8, 0.01
    end

    it "calculates 0 for a driver with no trips as a passenger or driver" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
                                     vin: "1C9EVBRM0YBC564DZ",
                                     phone: '111-111-1111',
                                    status: :AVAILABLE)
      expect(driver.net_expenditures).must_be_close_to 0.0, 0.01
    end

    it "does not include incomplete trips" do
      trip = RideShare::Trip.new(id: 14, driver: nil, passenger: @driver,
                                 start_time: Time.parse("2016-08-08"))

      net_expenditures = @driver.net_expenditures

      @driver.add_trip(trip)
      expect(@driver.net_expenditures).must_be_close_to net_expenditures, 0.01
      trip = RideShare::Trip.new(id: 14, driver: @driver, passenger: nil,
                                 start_time: Time.parse("2016-08-08"))
      @driver.add_driven_trip(trip)
      expect(@driver.net_expenditures).must_be_close_to net_expenditures, 0.01
    end
  end
end
