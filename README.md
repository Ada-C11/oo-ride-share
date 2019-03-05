# Ride Share

## At a Glance

- Pair, [stage 2](https://github.com/Ada-Developers-Academy/pedagogy/blob/master/rule-of-three.md#stage-2) project
- Due End of Day **Friday March 8th**

## Introduction

Remember the ride share exercise we did with designing and creating a system to track the ride share data from a CSV file? We did a lot of great work on creating arrays and hashes of data, but we've learned a lot since then!

Now, we're going to use our understanding of classes, methods and attributes to create an object-oriented implementation of our ride share system.

## Learning Goals

- Reinforce and practice Ruby programming fundamentals, particularly
  - Creating and instantiating classes with attributes
  - Using composition to connect different classes together
  - Working with files and large amounts of data
  - Writing pseudocode and creating tests to drive the creation of our code
- Quickly become familiar with a large and complex code base
- Use inheritance to extend existing classes

## Objective

We will build a Ruby library that loads lists of passengers, trips and drivers from CSV files, provides methods for exploring this data, and provides a way to request a new trip.

We will **not** write an interactive command-line program.

## Getting Started

We will use the same project structure we used for the previous project. Classes should be in files in the `lib` folder, and tests should be in files in the `specs` folder. You will run tests by executing the `rake` command, as configured in a Rakefile.

The `support` folder contains CSV files which will drive your system design. Each CSV corresponds to a different type of object _as well as_ creating a relationship between different objects.

### Setup
1.  You'll be working with an assigned pair. High-five your pair.
1.  Choose **one** person to fork this repository in GitHub
1.  Add the person who **didn't** fork the repository as a [collaborator](https://help.github.com/articles/inviting-collaborators-to-a-personal-repository/).
1.  Both individuals will clone the forked repo: $ git clone `[YOUR FORKED REPO URL]`
1.  Both partners `cd` into their project directory
1.  Run `rake` to run the tests

### Process
You should use the following process as much as possible:

1.  Write pseudocode
1.  Write test(s)
1.  Write code
1.  Refactor

### Pair Plan
Come up with a "plan of action" for how you want to work as a pair. Discuss your learning style, how you prefer to receive feedback, and one team communication skill you want to improve with this experience. Second, review the requirements for Wave 1 and come up with a plan for your implementation.

## Setup Requirements

This project comes with a large amount of scaffolding code already written. Before you start writing code, you and your partner should spend some time reading through what's here. Building a strong understanding now will make the rest of the project much smoother.

### Tests

Start by running the tests:

```
$ rake test
... test output ...
Finished in 0.14685s
28 tests, 64 assertions, 0 failures, 0 errors, 1 skips
```

All the existing code is thoroughly tested. Some of the code you write for this project will break these tests; when that happens, it is your job to update them. When you add new functionality to this project, you should add new tests as well.

The tests can serve as an example of how the methods and classes should work. If you're ever confused about what one of these methods looks like "from the outside", the tests can serve as your guide.

### Reading Code

The existing code contains 4 classes:
- `Passenger`
- `Trip`
- `CsvRecord`
- `TripDispatcher`

**Before you go any further, think about how these classes might be related.** Draw a diagram, if that will help. Your guess doesn't have to be correct at this stage - making a prediction and then checking it is an important part of the learning process.

Now, start reading through the code. There are two equally valid ways to approach this:

- Top-down: start with the big pieces.
    - What classes are there, and how do they interact?
    - How does it look from the outside?
    - How are these classes tested?
- Bottom-up: start with the details. Pick an interesting method (say `Passenger.load_all`) and learn everything about it.
    - What arguments does it take?
    - How does it work? If there's more than one step, what are they? Why are they in that order?
    - What other methods does call? 
    - What does it return?
    - What code calls it, and how does it use the returned value?
    - How is it tested?

### Playing Around

One of the most effective way to learn a new codebase is to use it. Since this code is a library not a program, there's nothing obvious to run from the command line, so we'll have to be a little clever. We can use `pry` to load the code, and then play with it in the interpreter:

```
$ pry -r ./lib/trip_dispatcher.rb
[1] pry(main)> td = RideShare::TripDispatcher.new
=> #<RideShare::TripDispatcher:0x3fe91f52950c>
[2] pry(main)> td.trips.length
=> 600
```

### Comprehension Questions

Before you start writing code, you and your partner should use the above techniques and work together to answer the following questions. If you have questions or run into something that you can't figure out, consult with another group.

#### Classes and Relationships

- What _inheritance_ relations exist between classes?
- What _composition_ relations exist between classes?
- Do these relations match your prediction from earlier?
- Draw a class diagram that contains all of the above relations.

#### Code Details

- Why doesn't `Passenger` or `Trip` need an `attr_reader` for `id`? 
    Because they both inherit the attr_reader methods from CsvRecord

- Why does `from_csv` in `CsvRecord` raise a `NotImplementedError`? What does this mean? Why don't we hit that when we run the code?
    It raises this error because we have not yet implemented this method yet!

    This is a private method so it is not accessible outside of the CsvRecord class. Hence, it's not accessible by the test file. (We think.)

- Why is `from_csv` a private method?
    We don't want other classes to be able to access it. 
    
    We suspect this is because we'll want CsvRecord to be able to pull information from a csv file but then not rely on accessing the csv file and instead storing / manipulating the information within the program.

- How does `CsvRecord.load_all` know what CSV file to open? 
    self.load_all takes parameters for the file path (full_path), directory or file_name. It then builds a path to the CSV file using build_path(directory, file_name).

- When you call `Passenger.load_all`, what happens? What methods are called in what order?
    1) The .load_all method is called on the Passenger class. This method is inherited from the CsvRecord class.
    2) This method checks if the full path is given and if not, it uses the build_path method to generate the file path.
    3) Next, the CSV gem uses .read to ingest the data from the csv file.
    4)  The .map function iterates over each line (row) of the csv file, stores it in an array and then puts that array into a larger array. (Essentially, the .map function makes an array of arrays from the csv file.)
    5) The array of arrays is returned.

#### Using the Library

Using the pry session we started above, how would you...

- Print the rating for the first trip
- Print the name of the passenger for trip 7
- Print the ID of every trip taken by passenger 9
- Print the ID of the trip that cost the most money

[3] pry(main)> td.trips.length
=> 600
[4] pry(main)> td.trips[1].rating
=> 4
[5] pry(main)> td.trips[6].passenger.name
=> "Melvin Gerlach DDS"
[6] pry(main)> td.find_passenger(9).trips
=> [#<RideShare::Trip:0x3fc5be121718 ID=20 PassengerID=9>,
 #<RideShare::Trip:0x3fc5be595948 ID=296 PassengerID=9>]
[7] pry(main)> td.find_passenger(9).trips.each do |trip|
[7] pry(main)*   puts trip.id
[7] pry(main)* end  
20
296

[2] pry(main)> exit

Elles-Air:oo-ride-share elle$ pry -r ./lib/trip_dispatcher.rb
[1] pry(main)> td = RideShare::TripDispatcher.new
=> #<RideShare::TripDispatcher:0x3fdadc5a5e00>
[2] pry(main)> td.trips.length
=> 600


[3] pry(main)> all_trip_costs = []
=> []
[4] pry(main)> td.trips.each do |this_trip|
[4] pry(main)*   all_trip_costs << this_trip.cost
[4] pry(main)* end  
=> [#<RideShare::Trip:0x3fdadc572a8c ID=1 PassengerID=54>,
 #<RideShare::Trip:0x3fdadc572744 ID=2 PassengerID=107>,
 #<RideShare::Trip:0x3fdadc572028 ID=3 PassengerID=66>,
 #<RideShare::Trip:0x3fdadc5713bc ID=4 PassengerID=148>,
 #<RideShare::Trip:0x3fdadc56ffd0 ID=5 PassengerID=105>,
 #<RideShare::Trip:0x3fdadc56f9a4 ID=6 PassengerID=118>,
 #<RideShare::Trip:0x3fdadc56ec70 ID=7 PassengerID=3>,
 #<RideShare::Trip:0x3fdadc56db90 ID=8 PassengerID=129>,
 ...
 #<RideShare::Trip:0x3fdadc5540f0 ID=33 PassengerID=97>,
 #<RideShare::Trip:0x3fdadc5538d0 ID=34 PassengerID=61>,
 #<RideShare::Trip:0x3fdadc553600 ID=35 PassengerID=86>,
 #<RideShare::Trip:0x3fdadc55340c ID=36 PassengerID=114>,
[5] pry(main)> puts all_trip_costs
10
18
20
6
11
...
24
11
22
24
9
=> nil


[7] pry(main)> all_trip_costs.max
=> 30



## Implementation Requirements

### Wave 1: Extending Existing Classes

The purpose of Wave 1 is to help you become familiar with the existing code, and to practice working with enumerables.

#### 1.1: Upgrading Times

Currently our implementation saves the start and end time of each trip as a string. This is our first target for improvement. Instead of storing these values as strings, we will use [Ruby's built-in `Time` class](https://ruby-doc.org/core-2.5.1/Time.html). You should:

1.  Spend some time reading the docs for `Time` - you might be particularly interested in `Time.parse`
1.  Modify `Trip#initialize` to turn `start_time` and `end_time` into `Time` instances before saving them
1.  Add a check in `Trip#initialize` that raises an `ArgumentError` if the end time is before the start time, **and a corresponding test**
1.  Add an instance method to the `Trip` class to calculate the _duration_ of the trip in seconds, **and a corresponding test**

**Hint:** If you're hitting a `NoMethodError` for `Time.parse`, be aware that you need to `require 'time'` in order for it to work.

#### 1.2: Passenger Methods

Now that we have data for trip time stored in a more convenient way, we can do some interesting data processing. Each of these should be implemented as an instance method on `Passenger`.

1.  Add an instance method, `net_expenditures`, to `Passenger` that will return the _total amount of money_ that passenger has spent on their trips
1.  Add an instance method,  `total_time_spent` to `Passenger` that will return the _total amount of time_ that passenger has spent on their trips

**Each of these methods must have tests.** What happens if the passenger has no trips?

### Wave 2: Drivers

Our program needs a data type to represent Drivers in our service.

We will do this by creating a `Driver` class which inherits from `CsvReader`, similar to `Trip` and `Passenger`.  The constructor for `Driver` should take the following keyword arguments:

| Attribute | Description                                      | Rules                                                                            |
|-----------|--------------------------------------------------|----------------------------------------------------------------------------------|
| `id`      | Unique number for this driver                    | Pass to the superclass constructor (similar to `Passenger`)                      |
| `name`    | This driver's name                               |                                                                                  |
| `vin`     | The driver's Vehicle Identification Number (VIN) | String of length 17. Raise an `ArgumentError` if it's the wrong length.          |
| `status`  | Is this `Driver` available to drive?             | Must be one of `:AVAILABLE` or `:UNAVAILABLE`                                    |
| `trips`   | A list of trips this driver has driven           | Optional, if not provided, initialize to an empty array (similar to `Passenger`) |

Since `Driver` inherits from `CsvRecord`, you'll need to implement the `from_csv` template method. Once you do, `Driver.load_all` should work (test this in pry).

**Use the provided tests** to ensure that a `Driver` instance can be created successfully and that an `ArgumentError` is raised for an invalid status.

#### Updating Trip

To make use of the new `Driver` class we will need to update the `Trip` class to include a reference to the trip's driver.  Add the following attributes to the `Trip` class.

| Attribute   | Description                        |
|-------------|------------------------------------|
| `driver_id` | The ID of the driver for this trip |
| `driver`    | The `Driver` instance for the trip |

When a `Trip` is constructed, either `driver_id` or `driver` must be provided.

**Note:** You have changed the method signature of the constructor for `Trip`. Some of your tests may now be failing. Go fix them!

#### Loading Drivers
Update the `TripDispatcher` class as follows:

- In the constructor, call `Driver.load_all` and save the result in an instance variable
- Update the `connect_trips` method to connect the driver as well as the passenger
- Add a `find_driver` method that looks up a driver by ID

#### Driver methods

After each `Trip` has a reference to its `Driver` and `TripDispatcher` can load a list of `Driver`s, add the following functionality to the `Driver` class:

| Method         | Description                                                                                                                                                   | Test Cases                                                                                                                                    |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| add_trip       | Add a trip to the driver's list of trips                                                                                                                      | Try adding a trip                                                                                                                             |
| average_rating | What is this driver's average rating?                                                                                                                         | What if there are no trips?<br><br>Does it handle floating point division correctly? For example the average of 2 and 3 should be 2.5, not 2. |
| total_revenue  | This method calculates that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted. | What if there are no trips?<br><br>What if the cost of a trip was less that $1.65?                                                            |

**All the new methods above should have tests**

#### Aside: More OO Design

<details>
<summary>Expand for musings on object-oriented design</summary>
You may notice that `Driver` and `Passenger` share a lot of traits, especially the ability to work with a list of trips. If we were to flesh this library out more, you could imagine having a lot of repeated code. Addressing this problem is an interesting challenge.

One way we could DRY this up is through more inheritance (perhaps a `TripTaker` class), but inheritance is a little heavy-handed for our purposes. A more appropriate technique might be to use a module to include common behavior - this is the topic of POODR chapter 7.

For right now, we'll just let `Passenger` and `Driver` have some repeated code.
</details>

### Wave 3: Requesting a Trip

Our program needs a way to make new trips and appropriately assign a driver and passenger.

This logic will be handled by our `TripDispatcher` in a new instance method: `TripDispatcher#request_trip(passenger_id)`. When we create a new trip with this method, the following will be true:
- The passenger ID will be supplied (this is the person requesting a trip)
- Your code should automatically assign a driver to the trip
    - For this initial version, choose the first driver whose status is `:AVAILABLE`
- Your code should use the current time for the start time
- The end date, cost and rating will all be `nil`
    - The trip hasn't finished yet!

You should use this information to:

- Create a new instance of `Trip`
- Modify this selected driver using a new helper method in `Driver`:
    - Add the new trip to the collection of trips for that `Driver`
    - Set the driver's status to `:UNAVAILABLE`
- Add the `Trip` to the `Passenger`'s list of `Trip`s
- Add the new trip to the collection of all `Trip`s in `TripDispatcher`
- Return the newly created trip

**All of this code must have tests.** Things to pay attention to:
- Was the trip created properly?
- Were the trip lists for the driver and passenger updated?
- Was the driver who was selected `AVAILABLE`?
- What happens if you try to request a trip when there are no `AVAILABLE` drivers?

#### Interaction with Waves 1 & 2

One thing you may notice is that **this change breaks your code** from previous waves, possibly in subtle ways. We've added a new kind of trip, an _in-progress_ trip, that is missing some of the values you need to compute those numbers.

Your code from waves 1 & 2 should _ignore_ any in-progress trips. That is to say, any trip where the end time is `nil` should not be included in your totals.

You should also **add explicit tests** for this new situation. For example, what happens if you attempt to calculate the total money spent for a `Passenger` with an in-progress trip, or the average rating of a `Driver` with an in-progress trip?

### Optional Wave 4: Intelligent Dispatching

**This wave is optional!** Don't even look at it until you're sure your code from the previous waves meets every requirement!

We want to evolve `TripDispatcher` so it assigns drivers in more intelligent ways. Every time we make a new trip, we want to pick drivers who haven't completed a trip in a long time, or who have never been assigned a trip.

In other words, we should assign the driver to **the available driver who has never driven or lacking a new driver one whose most recent trip ending is the oldest compared to today.**

Modify `TripDispatcher#request_trip` to use the following rules to select a `Driver`:
- The `Driver` must have a status of `AVAILABLE`
- The `Driver` must not have any in-progress trips (end time of `nil`)
- From the `Driver`s that remain, select the one who has never driven or whose most recent trip ended the longest time ago

For example, if we have three drivers, each with two trips:

| Driver Name | Status        | Trip 1 end time | Trip 2 end time                                                                         |
|-------------|---------------|-----------------|-----------------------------------------------------------------------------------------|
| Ada         | `AVAILABLE`   | Jan 3, 2018     | Jan 9, 2018                                                                             |
| Katherine   | `AVAILABLE`   | Jan 1, 2018     | Jan 12, 2018                                                                            |
| Grace       | `UNAVAILABLE` | Jan 5, 2018     | `nil`           ` ` ` ` ` ` ` ` ` ` |` ` |` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` |` ` ` ` |` |              

Grace is excluded because they are not `AVAILABLE`, and because they have one in-progress trip.

Of Ada and Katherine, we prefer Ada, because their most recent trip is older.

**All of this code must have tests.**

## What Instructors Are Looking For
Check out the [feedback template](feedback.md) which lists the items instructors will be looking for as they evaluate your project.
