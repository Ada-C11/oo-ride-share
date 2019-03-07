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
  let(:dispatcher) {
    build_test_dispatcher
  }
  let(:new_trip) {
    dispatcher.request_trip(dispatcher.passengers[1].id)
  }
  describe "TripDispatcher#request_trip" do
    it "will return Trip class" do
      expect(new_trip).must_be_instance_of RideShare::Trip
    end

    it "will assign the first available driver to the new trip instance" do
      driver = dispatcher.drivers.find do |driver|
        driver.status == :AVAILABLE
      end
      expect(new_trip.driver).must_equal driver
    end

    it "will changed the assigned driver's status to :UNAVAILABLE" do
      expect(new_trip.driver.status).must_equal :UNAVAILABLE
    end

    it "the new trip id will be the next sequentially available id" do
      expect(new_trip.id).must_equal dispatcher.trips.length
    end

    it "the trip will be added to the driver's trips" do
      expect(new_trip.driver.trips[-1]).must_equal new_trip
    end

    it "the trip will be added to the passenger's trips" do
      expect(new_trip.passenger.trips[-1]).must_equal new_trip
    end

    it "the trip will be added to the Dispatcher's trips" do
      p new_trip
      p dispatcher.trips[-1]
      expect(dispatcher.trips[-1]).must_equal new_trip
    end

    it "new trip's end time should be nil" do
      expect(new_trip.end_time).must_be_nil
    end

    it "new trip's cost should be nil" do
      expect(new_trip.cost).must_be_nil
    end

    it "new trip's rating should be nil" do
      expect(new_trip.rating).must_be_nil
    end

    it "raise exception if no avaiable drivers" do
      dispatcher.drivers.each do |driver|
        driver.status = :UNAVAILABLE
      end
      expect {
        dispatcher.request_trip(dispatcher.passengers[2].id)
      }.must_raise NoDriverAvailableError
    end
  end
end
