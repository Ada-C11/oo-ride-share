require "csv"

driver_csv = CSV.open("./drivers.csv", "w+",
                      write_headers: true, headers: [:id, :name, :vin, :status])
passenger_csv = CSV.open("./passengers.csv", "w+",
                         write_headers: true,
                         headers: [:id, :name, :phone_num])
trips_csv = CSV.open("./trips.csv", "w+",
                     write_headers: true,
                     headers: [:id, :driver_id, :passenger_id, :start_time,
                               :end_time, :cost, :rating])

drivers = [
  {id: 1, name: "Driver 1 (unavailable)", vin: "1B6CF40K1J3Y74UY0", status: "UNAVAILABLE"},
  {id: 2, name: "Driver 2", vin: "1B6CF40K1J3Y74UY2", status: "AVAILABLE"},
  {id: 3, name: "Driver 3 (no trips)", vin: "1C6CF40K1J3Y74UY2", status: "AVAILABLE"},
]
passengers = [
  {id: 1, name: "Passenger 1", phone_num: "111-111-1111"},
  {id: 2, name: "Passenger 2", phone_num: "111-111-1112"},
  {id: 3, name: "Passenger 3", phone_num: "111-111-1113"},
  {id: 4, name: "Passenger 4", phone_num: "111-111-1114"},
  {id: 5, name: "Passenger 5", phone_num: "111-111-1115"},
  {id: 6, name: "Passenger 6", phone_num: "111-111-1116"},
  {id: 7, name: "Passenger 7", phone_num: "111-111-1117"},
  {id: 8, name: "Passenger 8", phone_num: "111-111-1118"},
]

trips = [
  {id: 1, driver_id: 1, passenger_id: 1,
   start_time: "2018-05-25 11:52:40 -0700",
   end_time: "2018-05-25 12:25:00 -0700", cost: 10, rating: 5},
  {id: 2, driver_id: 1, passenger_id: 3,
   start_time: "2018-05-25 04:39:00 -0700",
   end_time: "2018-05-25 04:55:00 -0700", cost: 7, rating: 3},
  {id: 3, driver_id: 2, passenger_id: 4,
   start_time: "2018-06-11 22:22:00 -0700",
   end_time: "2018-06-11 22:57:00 -0700", cost: 15, rating: 4},
  {id: 4, driver_id: 2, passenger_id: 7,
   start_time: "2018-08-12 15:04:00 -0700",
   end_time: "2018-08-12 15:14:00 -0700", cost: 8, rating: 1},
  {id: 5, driver_id: 2, passenger_id: 6,
   start_time: "2018-08-05 08:58:00 -0700",
   end_time: "2018-08-05 09:30:00 -0700", cost: 32, rating: 1},
]

drivers.each do |driver|
  driver_csv << driver
end

passengers.each do |passenger|
  passenger_csv << passenger
end

trips.each do |trip|
  trips_csv << trip
end
