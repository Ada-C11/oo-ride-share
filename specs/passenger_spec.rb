require_relative "spec_helper"

describe "Passenger class" do
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end

    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end

      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end

  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      @driver = RideShare::Driver.new(
        id: 8,
        name: "Finn Glover III",
        vin: "12345678987654321",
        status: :UNAVAILABLE,
        trips: [],
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver: @driver,
        start_time: "2016-08-08",
        end_time: "2016-08-09",
        rating: 5,
        driver_id: 8,
      )

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end

  describe "Passenger totals" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: [],
      )
      # TRIP 1
      start_time = Time.parse("2015-05-20T12:14:00+00:00")
      end_time = start_time + 25 * 60 # 25 minutes
      @trip_data_1 = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 23.45,
        rating: 3,
        driver_id: 8,
      }
      @trip_1 = RideShare::Trip.new(@trip_data_1)
      @passenger.add_trip(@trip_1)

      # TRIP 2
      start_time = Time.parse("2015-05-21T12:14:00+00:00")
      end_time = start_time + 5 * 60 # 5 minutes
      @trip_data_2 = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 5.00,
        rating: 3,
        driver_id: 7,
      }
      @trip_2 = RideShare::Trip.new(@trip_data_2)
      @passenger.add_trip(@trip_2)

      # TRIP 3
      start_time = Time.parse("2015-05-22T12:14:00+00:00")
      end_time = start_time + 10 * 60 # 10 minutes
      @trip_data_3 = {
        id: 8,
        passenger: RideShare::Passenger.new(id: 1,
                                            name: "Ada",
                                            phone_number: "412-432-7640"),
        start_time: start_time.to_s,
        end_time: end_time.to_s,
        cost: 9.00,
        rating: 3,
        driver_id: 6,
      }
      @trip_3 = RideShare::Trip.new(@trip_data_3)
      @passenger.add_trip(@trip_3)
    end

    # describe "net_expenditures" do
    #   # You add tests for the net_expenditures method
    # end
    
    it "calculate total amount spent on all trips taken by one passenger" do
      # trip_prices_array = []
      # @passenger.trips.each do |trip|
      #   trip_price = trip.cost
      #   trip_prices_array << trip_price
      # end
      # # ^^ this is the long way to write the map method below
      # trip_prices_array = @passenger.trips.map { |trip| trip.cost }

      amt_spent_total = @passenger.net_expenditures
      expect(amt_spent_total).must_equal 37.45
    end

    it "calculate total time spent on all trips taken by one passenger" do
      total_time = @passenger.total_time_spent
      expect(total_time).must_equal 2400
    end


  end
end
