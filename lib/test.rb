require_relative "passenger"
require_relative "trip"

module RideShare
  puts "hello"
  passengers = Passenger.load_all(full_path: "/Users/shamiramarshall/ada/week-4/oo-ride-share/specs/test_data/passengers.csv")

  trips = Trip.load_all(full_path: "/Users/shamiramarshall/ada/week-4/oo-ride-share/specs/test_data/trips.csv")

  puts trips
end
