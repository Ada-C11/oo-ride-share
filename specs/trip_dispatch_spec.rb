require_relative 'spec_helper'

TEST_DATA_DIRECTORY = 'specs/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
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
        trip_count = %x{wc -l 'support/trips.csv'}.split(' ').first.to_i - 1

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
          expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
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

    describe "Request new trip" do
      before do
        @dispatcher = build_test_dispatcher  
      end
        
      it "requests a new trip with available driver" do
        ongoing_trip = @dispatcher.request_trip(1)
        expect(ongoing_trip.driver.status == :AVAILABLE)
      end
      
      it "updates driver trips when new trip is requested" do
        driver = @dispatcher.drivers[1]
        count = driver.trips.length
        
        new_trip = @dispatcher.request_trip(1)
        expect(new_trip.driver).must_equal driver
        expect(driver.trips.length).must_equal (count + 1)
      end

      it "updates passenger trips when new trip is requested" do
        passenger = @dispatcher.find_passenger(1)
        passenger_count = passenger.trips.length
        # new_trip = @dispatcher.request_trip(1)
        expect(passenger.trips.length).must_equal passenger_count + 1
      end

      it "returns an error when there are no available drivers" do
<<<<<<< HEAD
        dispatcher2 = build_test_dispatcher
        
        expect{(dispatcher2.request_trip(9))}.must_raise ArgumentError
||||||| merged common ancestors
        dispatcher2 = build_test_dispatcher
        available_driver = nil
        expect{(dispatcher2.request_trip(9))}.must_raise ArgumentError
=======
        @dispatcher.trips.each do |trip|
          trip.driver.status = :UNAVAILABLE
        end
        expect(@dispatcher.request_trip(2)).must_raise ArgumentError
>>>>>>> 76f9c269b487b83723425dc7d47825dd0eae3eab
      end
    end
 
end
