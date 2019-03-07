require_relative "spec_helper"

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
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end

      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      # expect(dispatcher.drivers).must_be_kind_of Array
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
    def build_test_dispatcher
      return RideShare::TripDispatcher.new(
               directory: TEST_DATA_DIRECTORY,
             )
    end

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
    describe "Request Trip" do
      before do
        # dispatcher = RideShare::TripDispatcher.new("./support")
        @passengers = RideShare::Passenger.load_all(directory: TEST_DATA_DIRECTORY)
        @trips = RideShare::Trip.load_all(directory: TEST_DATA_DIRECTORY)
        @drivers = RideShare::Driver.load_all(directory: TEST_DATA_DIRECTORY)
        @dispatcher = build_test_dispatcher
      end
      it "Returns trip" do
        trip = @dispatcher.request_trip(1)
        expect(trip).must_be_instance_of RideShare::Trip
      end

      # it "Finds available driver" do
      #   trip = dispatcher.request_new_trip(1)
      #   expect(trip.driver.status).must_equal :AVAILABLE
      # end

      it "Raises an error if no available drivers" do
        @drivers.each do |driver|
          driver.status = :UNAVAILABLE
        end
        expect { trip = @dispatcher.request_trip(1) }.must_raise ArgumentError
      end

      it "Adds a trip to passenger trip array" do
        passenger = @dispatcher.find_passenger(1)
        count = passenger.trips.count
        trip = @dispatcher.request_trip(1)
        expect(passenger.trips.count).must_equal count + 1
      end

      it "Adds a trip to dispatch trip array" do
        count = @dispatcher.trips.count
        trip = @dispatcher.request_trip(1)
        expect(@dispatcher.trips.count).must_equal count + 1
      end

      xit "available driver with no trips" do
        trip = @dispatcher.request_trip(1)
        expect(trip.driver.id).must_equal 3
      end

      it "longest time since last trip driver" do
        trip = @dispatcher.request_trip(1)
        expect(trip.driver.id).must_equal 4
      end
    end
  end
end
