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

    describe "request trip" do
      before do
        def build_test_dispatcher
          return RideShare::TripDispatcher.new(
                   directory: TEST_DATA_DIRECTORY,
                 )
        end
      end

      it "is an instance of Trip" do
        test_dispatcher = build_test_dispatcher
        expect(test_dispatcher.request_trip(1)).must_be_instance_of RideShare::Trip
      end
      it "updates trip lists for driver and passenger" do
        test_dispatcher = build_test_dispatcher
        new_trip = test_dispatcher.request_trip(1)

        expect(new_trip.passenger.trips).must_include new_trip
        expect(new_trip.driver.trips).must_include new_trip
      end

      it "only assigns available drivers" do
        test_dispatcher = build_test_dispatcher

        available_drivers = test_dispatcher.drivers.select { |driver| driver.status == :AVAILABLE }
        new_trip = test_dispatcher.request_trip(1)

        expect(available_drivers).must_include new_trip.driver
      end

      it "will change an assigned driver's status to :UNAVAILABLE" do
        test_dispatcher = build_test_dispatcher
        new_trip = test_dispatcher.request_trip(1)

        expect(new_trip.driver.status).must_equal :UNAVAILABLE
      end

      it "will return nil if no drivers are available" do
        test_dispatcher = build_test_dispatcher

        # select all available drivers
        count_available_drivers = test_dispatcher.drivers.count { |driver| driver.status == :AVAILABLE }

        # exhaust all available drivers
        count_available_drivers.times do |time|
          test_dispatcher.request_trip(1)
        end

        expect(test_dispatcher.request_trip(1)).must_be_nil
      end

      it "returns nil for unfinished trip's end time" do
        test_dispatcher = build_test_dispatcher
        new_trip = test_dispatcher.request_trip(1)

        expect(new_trip.end_time).must_be_nil
      end

      it "returns nil for unfinished trip's cost" do
        test_dispatcher = build_test_dispatcher
        new_trip = test_dispatcher.request_trip(1)

        expect(new_trip.cost).must_be_nil
      end

      it "returns nil for unfinished trip's rating" do
        test_dispatcher = build_test_dispatcher
        new_trip = test_dispatcher.request_trip(1)

        expect(new_trip.rating).must_be_nil
      end
    end
    describe "handles unfinished trips" do
      it "calculates total money spent for Passenger with unfinished trip" do
        test_dispatcher = build_test_dispatcher
        before = test_dispatcher.find_passenger(1).net_expenditures
        new_trip = test_dispatcher.request_trip(1)
        after = new_trip.passenger.net_expenditures
        expect(after).must_equal before
      end

      it "calculates total money spent if passenger's only trip is unfinished" do
        passenger = RideShare::Passenger.new(
          id: 9,
          name: "Merl Glover III",
          phone_number: "1-602-620-2330 x3723",
          trips: [],
        )
        trip1 = RideShare::Trip.new(
          id: 8,
          passenger: passenger,
          driver_id: 1,
          start_time: "2015-05-20T12:14:00+00:00",
          end_time: nil,
          cost: nil,
          rating: nil,
        )
        passenger.add_trip(trip1)

        expect(passenger.net_expenditures).must_equal 0
      end

      it "calculates average rating of Driver with unfinished trip" do
        test_dispatcher = build_test_dispatcher
        assigned_driver = test_dispatcher.intelligent_dispatch
        before = assigned_driver.average_rating
        new_trip = test_dispatcher.request_trip(1)
        after = new_trip.driver.average_rating
        expect(after).must_equal before
      end

      it "calculates driver average rating if only trip is incomplete" do
        test_driver = RideShare::Driver.new(id: 1,
                                            name: "Valentine",
                                            vin: "DF5S6HFG365HGDCVG",
                                            status: :AVAILABLE)
        trip1 = RideShare::Trip.new(
          id: 8,
          passenger_id: 8,
          driver_id: 1,
          start_time: "2015-05-20T12:14:00+00:00",
          end_time: nil,
          cost: nil,
          rating: nil,
        )

        test_driver.add_trip(trip1)

        expect(test_driver.average_rating).must_equal 0
      end

      it "calculates driver total revenue for Driver with unfinished trip" do
        test_dispatcher = build_test_dispatcher
        assigned_driver = test_dispatcher.intelligent_dispatch
        before = assigned_driver.total_revenue
        new_trip = test_dispatcher.request_trip(1)
        after = new_trip.driver.total_revenue
        expect(after).must_equal before
      end

      it "calculates total_revenue if only trip is incomplete" do
        test_driver = RideShare::Driver.new(id: 1,
                                            name: "Valentine",
                                            vin: "DF5S6HFG365HGDCVG",
                                            status: :AVAILABLE)
        trip1 = RideShare::Trip.new(
          id: 8,
          passenger_id: 8,
          driver_id: 1,
          start_time: "2015-05-20T12:14:00+00:00",
          end_time: nil,
          cost: nil,
          rating: nil,
        )

        test_driver.add_trip(trip1)

        expect(test_driver.total_revenue).must_equal 0
      end

      it "returns nil if calculating duration of unfinished trip" do
        test_dispatcher = build_test_dispatcher
        new_trip = test_dispatcher.request_trip(1)
        expect(new_trip.calculate_duration).must_be_nil
      end
      it "excludes unfinished trips in total time spent" do
        test_dispatcher = build_test_dispatcher
        before = test_dispatcher.find_passenger(1).total_time_spent
        new_trip = test_dispatcher.request_trip(1)
        after = new_trip.passenger.total_time_spent
        expect(after).must_equal before
      end
    end
    describe "intelligent dispatch" do
      before do
        @test_dispatcher = build_test_dispatcher
        @assigned_driver = @test_dispatcher.intelligent_dispatch
      end
      it "will assign an available driver" do
        expect(@assigned_driver.status).must_equal :AVAILABLE
      end
      it "will assign a driver that does not have an unfinished trip" do
        if @assigned_driver.trips.length > 0
          expect(@assigned_driver.trips.last.end_time).wont_be_nil
        else
          expect(@assigned_driver.trips.length).must_equal 0
        end
      end
      it "will prioritize assigning drivers with no previous trips" do
        @test_dispatcher.request_trip(1)
        expect(@assigned_driver.id).must_equal 3
        second_assigned_driver = @test_dispatcher.intelligent_dispatch
        expect(second_assigned_driver.id).must_equal 2
      end
    end
  end
end
