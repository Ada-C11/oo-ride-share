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
  describe "request_trip -- access correct information" do
    let (:trip) do
      @dispatcher = build_test_dispatcher
      passenger_id_new_trip = 1
      request_new_trip = @dispatcher.request_trip(passenger_id_new_trip)
    end

    it "will return instance of trip" do
      puts trip.object_id
      expect(trip).must_be_kind_of RideShare::Trip
    end
    it "new trip will have a correct new id" do
      puts trip.object_id
      expect(trip.id).must_equal 6
    end
    it "an available driver will be assigned to the new trip" do
      expect(trip.driver_id).must_equal 2
    end

    it "available driver status was changed to unavailable" do
      dispatcher = build_test_dispatcher
      before_dispatch_status = dispatcher.find_driver(2).status

      dispatcher.request_trip(1)

      after_dispatch_status = dispatcher.find_driver(2).status
      expect(before_dispatch_status).must_equal :AVAILABLE
      expect(after_dispatch_status).must_equal :UNAVAILABLE
    end

    it "passenger id corresponds to the right passenger" do
      expect(trip.passenger_id).must_equal 1
    end
    it "the start time corresponds to current time" do
      expect(trip.start_time).must_be_kind_of Time
    end
    it "end_time, cost, and rating are nil for a trip in progress" do
      expect(trip.end_time).must_be_kind_of NilClass
      expect(trip.cost).must_be_kind_of NilClass
      expect(trip.rating).must_be_kind_of NilClass
    end

    describe "request_trip -- updates the collections for drivers, passengers, and trips" do
      let (:dispatcher) do
        build_test_dispatcher
      end

      it "changes length of driver's trips" do
        drivers_length_before = dispatcher.find_driver(2).trips.length
        expect(drivers_length_before).must_equal 3

        dispatcher.request_trip(1)

        drivers_length_after = dispatcher.find_driver(2).trips.length
        expect(drivers_length_after).must_equal 4
      end

      it "changes length of all trips" do
        trips_length_before = dispatcher.trips.length
        expect(trips_length_before).must_equal 5

        dispatcher.request_trip(1)

        trips_length_after = dispatcher.trips.length
        expect(trips_length_after).must_equal 6
      end

      it "changes the length of passengers' trips" do
        passengers_length_before = dispatcher.find_passenger(1).trips.length
        expect(passengers_length_before).must_equal 1

        dispatcher.request_trip(1)

        passengers_length_after = dispatcher.find_passenger(1).trips.length
        expect(passengers_length_after).must_equal 2
      end

      it "will return nil with no available drivers" do
        dispatcher = build_test_dispatcher

        dispatcher.change_status(2)
        dispatcher.change_status(3)

        puts "Driver's status: #{dispatcher.find_driver(3).status}"

        expect(dispatcher.request_trip(1)).must_be_kind_of NilClass
      end
    end
  end
end
