require_relative 'csv_record'


module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: [])
      super(id)
    
      @name = name
      @vin = vin
      @status = status
      @trips = trips || []

      unless status.to_sym == :AVAILABLE || status.to_sym == :UNAVAILABLE
        raise ArgumentError, "Invalid status provided"
      end
      
      unless vin.length == 17
        raise ArgumentError, "Vin number must be 17 characters"
      end  
    end


    def add_trip(trip)
      @trips << trip
    end
    
    
    def average_rating
      if @trips.count == 0
        return 0
      end
      return (@trips.map{|trip| trip.rating}.sum).to_f/@trips.count
    end
    

    def total_revenue
      if @trips.length == 0 
        raise ArgumentError, "Driver has no trips."
      else
        raw_revenue = @trips.map{|trip| 
          unless trip.end_time == nil # ignore in-progress trips
            trip.cost
          end}.sum
        revenue = 0.8 * (raw_revenue - (trips.count * 1.65))
        return revenue
      end
    end


    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: (record[:status]).to_sym
      )
    end

#     Modify this selected driver using a new helper method in Driver:
# Add the new trip to the collection of trips for that Driver
# Set the driver's status to :UNAVAILABLE 
# Add the Trip to the Passenger's list of Trips
# Add the new trip to the collection of all Trips in TripDispatcher
# Return the newly created trip
# in_progress_trip = Trip.new(
#         id: 7,
#         passenger_id: passenger_id,
#         start_time: time,
#         end_time: nil, 
#         cost: nil, 
#         rating: nil,
#         driver: available_driver, 
#         driver_id: driver_id
#         )
    
    def accept_new_trip(trip)
      trip = Rideshare::TripDispatcher.request_new_trip
        add_trip(trip)
        trip.driver.status = :UNAVAILABLE 
    end
    
  end

end