require_relative "spec_helper"
require "time"

TEST_DATA_DIRECTORY = "specs/test_data"

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
             directory: TEST_DATA_DIRECTORY,
           )
  end

  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers, :drivers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
    end

    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(" ").first.to_i - 1

      dispatcher = RideShare::TripDispatcher.new

      expect(dispatcher.trips.length).must_equal trip_count
    end
  end

  describe "passengers" do
    describe "find_passenger method" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end

      it "finds a passenger instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end
    end

    describe "Passenger & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "accurately loads passenger information into passengers array" do
        first_passenger = @dispatcher.passengers.first
        last_passenger = @dispatcher.passengers.last

        expect(first_passenger.name).must_equal "Passenger 1"
        expect(first_passenger.id).must_equal 1
        expect(last_passenger.name).must_equal "Passenger 8"
        expect(last_passenger.id).must_equal 8
      end

      it "connects trips and passengers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.passenger).wont_be_nil
          expect(trip.passenger.id).must_equal trip.passenger_id
          expect(trip.passenger.trips).must_include trip
        end
      end
    end
  end

  # TODO: un-skip for Wave 2
  describe "drivers" do
    describe "find_driver method" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end

      it "finds a driver instance" do
        driver = @dispatcher.find_driver(2)
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end

    describe "Driver & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end

      it "accurately loads driver information into drivers array" do
        first_driver = @dispatcher.drivers.first
        last_driver = @dispatcher.drivers.last

        expect(first_driver.name).must_equal "Driver 1 (unavailable)"
        expect(first_driver.id).must_equal 1
        expect(first_driver.status).must_equal :UNAVAILABLE
        expect(last_driver.name).must_equal "Driver 3 (no trips)"
        expect(last_driver.id).must_equal 3
        expect(last_driver.status).must_equal :AVAILABLE
      end

      it "connects trips and drivers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.driver).wont_be_nil
          expect(trip.driver.id).must_equal trip.driver_id
          expect(trip.driver.trips).must_include trip
        end
      end
    end
  end
  describe "request_trip" do
    ## NOT SURE IF WE SHOULD ADD
    # before do
    #   start_time = Time.parse("2015-05-20T12:14:00+00:00")
    #   end_time = start_time + 25 * 60 # 25 minutes
    #   @trip_data = {
    #     id: 8,
    #     passenger: RideShare::Passenger.new(id: 1,
    #                                         name: "Ada",
    #                                         phone_number: "412-432-7640"),
    #     start_time: start_time.to_s,
    #     end_time: end_time.to_s,
    #     cost: 23.45,
    #     rating: 3,
    #     driver: nil,
    #   }
    # @trip = RideShare::Trip.new(@trip_data)

    it "will return instance of trip" do
      dispatcher = build_test_dispatcher
      # create a new trip in request_trip
      #     instantiate Trip in TripDispatch ang pass the passenger id, OK
      #     trip id which will be the lenght of the @trips array OK
      #      start time Time.now (figure what format to give to the initialize as... I believe it should be string in .new) OK
      # find passenger that is requesting the new trip using the id given --> I THINK WE DON'T NEED TO FIND THE PASSENGER WHEN CREATING THE TRIP
      # find a driver from list that's available from a list check status OK
      # change driver status to unavailable -> by using the helper method OK added driver.find(driver_new_trip).status = :UNAVAILABLE in request_trip
      #   in Driver class (change attr_reader for status or do the change within an instance method????)
      # create the trip with a new time which is the current time Time.now
      # set end date, cost, and rating to nil
      # the trip hasn't finished ########
      # add a new trip instance to the collection in Passenger, Driver, and Tripdispatcher
      # return the newly created trip (instance of Trip)

      ## NOT SURE IF WE SHOULD ADD
      # @passenger = RideShare::Passenger.new(
      #   id: 9,
      #   name: "Merl Glover III",
      #   phone_number: "1-602-620-2330 x3723",
      #   trips: [],
      # )
      #

      expect(dispatcher.request_trip(1)).must_be_kind_of RideShare::Trip
    end
  end
end
