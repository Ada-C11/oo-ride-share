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
      [:trips, :passengers].each do |prop|
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
        driver = @dispatcher.find_driver(3)
        expect(passenger).must_be_kind_of RideShare::Passenger
        # expect(driver).must_be_kind_of RideShare::Driver
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

  describe "Requesting a Trip" do
    describe "new trip request functionality" do
      before do
        # Creates an instance of TripDispatcher
        @dispatcher = build_test_dispatcher

        # start_time = Time.parse("2015-05-20T12:14:00+00:00")
        start_time = Time.now
        end_time = start_time + 25 * 60 # 25 minutes
        @trip_data = {
          id: 8,
          passenger: RideShare::Passenger.new(id: 1,
                                              name: "Ada",
                                              phone_number: "412-432-7640"),
          start_time: start_time.to_s,
          end_time: end_time.to_s,
          cost: 23.45,
          rating: 3,
          driver: RideShare::Driver.new(
            id: 1,
            name: "Lovelace",
            vin: "12345678987658456",
          ),
        }
        @trip = RideShare::Trip.new(@trip_data)
      end
      it "creates an instance of Trip" do
        expect(@trip).must_be_kind_of RideShare::Trip # PASSES 
      end

      xit "sets the start_time of the trip to Time.now" do
        time_diff = Time.now - @trip.start_time
        expect(time_diff).must_be_within_delta 1.0 #=> FAILS
      end

      xit "sets the end_time, cost and rating of the trip appropriately" do
        # expect(@trip.end_time).must_equal nil
        # expect (@trip.cost).must_equal nil
        # expect (@trip.rating).must_equal nil
      end

      # it "adds the trip to the driver's trips array" do
        # # Creates an instance of TripDispatcher class
        # @dispatcher = build_test_dispatcher
        

        # requesting_passenger = @dispatcher.find_passenger(1)
        # # dipatcher sends request to first available driver
        # available_driver = @dispatcher.find_available_driver
        # # expect(available_driver.trips).wont_include new_trip

        # new_trip = @dispatcher.request_trip(requesting_passenger.id)

        # expect(available_driver.trips).must_include new_trip
      # end



      it "Adds new trip to driver @trips array" do
        trip = @dispatcher.request_trip(1)

        expect(trip.driver.trips).must_include trip
      end

      it "Adds new trip to passenger @trips array" do
        trip = @dispatcher.request_trip(1)
        passenger = @dispatcher.find_passenger(1)

        expect(trip.passenger.trips).must_include trip
      end

      it "Adds new trip to dispatcher @trips array" do
        trip = @dispatcher.request_trip(1)
        expect(@dispatcher.trips).must_include trip
      end


      xit "adds the trip to the passenger's trips array" do
      end

      xit "adds the trip to the collection of all trips in TripDispatcher" do
      end

      xit "changes the driver's status from available to unavailable" do
      end

      xit "returns a helpful message when there are no available drivers" do
      end
    end
  end
end






# def request_trip(passenger_id)
#       passenger = find_passenger(passenger_id)
#       driver = find_next_available_driver
#       id = @trips.length + 1
#       new_trip = RideShare::Trip.new(id: id, passenger: passenger, passenger_id: passenger.id, driver: driver, start_time: Time.now.to_s, end_time: nil, rating: nil)
#       @trips << new_trip
#       new_trip.passenger.add_trip(new_trip)
#       new_trip.driver.add_trip(new_trip)

#       return new_trip
#     end