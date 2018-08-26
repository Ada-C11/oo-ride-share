# Ride Share
Remember the ride share exercise we did with designing and creating a system to track the ride share data from a CSV file? We did a lot of great work on this exercise in creating arrays and hashes of data, but we've learned a lot since we did that exercise!

Now, we're going to use our understanding of classes, methods and attributes to create an object-oriented implementation of our ride share system.

This is a [level 2](https://github.com/Ada-Developers-Academy/pedagogy/blob/master/rule-of-three.md) pair project.

## Learning Goals
Reinforce and practice all of the Ruby and programming concepts we've covered in class so far:
-   Creating and instantiating classes with attributes
-   Writing pseudocode and creating tests to drive the creation of our code
-   Using Inheritance to extend classes
-   Using Composition to add functionality to classes


## Context
We have a code base that already pulls data from CSV files and turns them into collections of the following objects:
-   `User`s
-   `Trip`s

All of this data is managed in a class called `TripDispatcher`. Our program will contain _one_ instance of `TripDispatcher`, which will load and manage the lists of `Driver`s, `User`s and `Trip`s.

We are going to continue making functionality that works with this data, such as determining the duration of a specific trip and the total amount of money a user has spent, as well as the amount of money a driver has made and also add functionality to create a new trip and assign available drivers.

### The Code So Far

#### User
A `User` represents a person with an account in our Rideshare service.  `Users` can use the service to take trips and can become Drivers with the service.

Each `User` has:

**Attribute**|**Description**
-----|-----
id|The User's ID number
name|The name of the User
Phone Number|The User's Phone Number which must be in phone number format (XXX) XXX-XXXX
trips|A list of trips that this User has taken as a passenger

User Methods

**Method**|**Description**
-----|-----
add_trip|Adds a trip to the user's list of trips


#### Trip
A `Trip` represents a journey a `User` has taken with the service.

Each `Trip` has:

**Attribute**|**Description**
-----|-----
id|The Trip's ID number
passenger|The User being transported on the trip
start_time|When did this trip begin?
end_time|When did this trip finish?
rating|The rating given by the User, a number 1-5
cost|How much did the passenger pay?
passenger|The User being transported on the trip

#### TripDispatcher
The `TripDispatcher` class is designed to load trips & users from a CSV file and provides methods to find and add trips.

The `TripDispatcher` has:

**Attribute**|**Description**|**Returns**
-----|-----|-----
passengers|A list of all users in the system|a collection of User instances
trips|A list of all trips taken in the system|a collection of Trip instances

The `TripDispatcher` has the following responsibilities:
-   load collections of `User`s, and `Trip`s from CSV files
-   store and manage this data into separate collections

The `TripDispatcher` does the following:
-   on instantiation, loads and creates `Trip`s, and `User`s, and stores them into collections

The `TripDispatcher` instance is able to:

**Methods**|**Description**
-----|-----
load_users|A method which loads users from a CSV file, returning the list
load_trips|A method which loads trips from a CSV file, returning the list
find_passenger  |  find an instance of `User` given an ID

By the end of this project, a `TripDispatcher` will be able to:
-   create new trips assigning appropriate passengers and drivers

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
1.  Together review the provided tests and code.

### Process
You should use the following process as much as possible:

1.  Write pseudocode
1.  Write test(s)
1.  Write code
1.  Refactor

## Requirements

### Pair Plan
First, come up with a "plan of action" for how you want to work as a pair. Discuss your learning style, how you prefer to receive feedback, and one team communication skill you want to improve with this experience. Second, review the requirements for Wave 1 and come up with a "plan of action" for your implementation.

### Baseline

To start this project, take some time to get familiar with the code. Do the following in this order:
1. Read through all of the tests
1. Look at the provided CSV files: `support/drivers.csv`, `support/users.csv`, `support/trips.csv`
1. Then look through the ruby files in the `lib` folder

Create a diagram that describes how each of these classes and methods (messages) interact with one another as well as with the CSV files.

**Exercise:** Look at this requirement in Wave 1: "For a given user, calculate their total expenditure for all trips. Spend some time writing pseudocode for this.

### Wave 1

The purpose of Wave 1 is to help you become familiar with the existing code, and to practice working with enumerables.

#### 1.1: Upgrading Dates

Currently our implementation saves the start and end time of each trip as a string. This is our first target for improvement. Instead of storing these values as strings, we will use Ruby's built-in [`Time`](https://ruby-doc.org/core-2.5.1/Time.html) class. You should:

1.  Spend some time reading the docs for `Time` - you might be particularly interested in `Time.parse`
1.  Modify `TripDispatcher#load_trips` to store the `start_time` and `end_time` as `Time` instances
1.  Add a check in `Trip#initialize` that raises an `ArgumentError` if the end time is before the start time, **and a corresponding test**
1.  Add an instance method to the `Trip` class to calculate the _duration_ of the trip in seconds, and a corresponding test

**Hint:** If you're hitting a `NoMethodError` for `Time.parse`, be aware that you need to `require 'time'` in order for it to work.

#### 1.2: User Aggregate Statistics

Now that we have data for cost available for every trip, we can do some interesting data processing. Each of these should be implemented as an instance method on `User`.

1.  Add an instance method, `net_expenditures`, to `User` that will return the _total amount of money_ that user has spent on their trips
1.  Add an instance method,  `total_time_spent` to `User` that will return the _total amount of time_ that user has spent on their trips

**Each of these methods must have tests.**

### Wave 2

Our program needs a data type to represent Drivers in our service.

We will do this by creating a `Driver` class which inherits from `User`.  A `Driver` will add the following data attributes:

**Attribute**|**Description**
-----|-----
vehicle\_identification|The driver's Vehicle Identification Number (VIN Number), Each vehicle identification number should be a specific length of 17 to ensure it is a valid vehicle identification number
driven_trips | A list of trips the user has acted as a driver for.
status|Indicating availability, a driver's availability should be either `:AVAILABLE` or `:UNAVAILABLE`

**Create tests** to ensure that a `Driver` instance can be created successfully and insure that an `ArgumentError` is raised for an invalid status.

#### Updating Trip

To make use of the new `Driver` class we will need to update the `Trip` class to include a reference to the trip's driver.  Add the following attribute to the `Trip` class.

**Attribute**|**Description**
-----|-----
driver|The `Driver` for the trip

Each `Trip` instance should also be able to do the following:

**Method**|**Description**
-----|-----
driver|retrieve the associated `Driver` instance

#### Loading Drivers
Update the `TripDispatcher` class to add or update the following Methods:

**Method**|**Description**
-----|-----
load_drivers|Load the Drivers from the `support/drivers.csv` file and return a collection of `Driver` instances
find_driver |This method takes an `id` number and returns the corresponding `Driver` instance.
load_trips|This method should be updated to add a corresponding `Driver` to the trip instance.

#### Driver methods

After each trip has a reference to its `Driver` and TripDispatcher can load a list of `Driver`s, add the following functionality to the `Driver` class:

**Method**|**Description**
-----|-----
average_rating  |  This method sums up the ratings from all a Driver's trips and returns the average
add_trip  |  This method adds a trip to the driver's collection of trips
total_revenue  |  This method calculates that driver's total revenue across all their trips. Each driver gets 80% of the trip cost after a fee of $1.65 per trip is subtracted.
net_expenditures|This method will **override** the cooresponding method in `User` and take the total amount a driver has spent as a passenger and subtract the amount they have earned as a driver (see above).  If the number is negative the driver will earn money.


**All the new methods should have tests**

# Wave 3

Our program needs a way to make new trips and appropriately assign a driver and user.

This logic will be handled by our `TripDispatcher` in a new instance method: `TripDispatcher#request_trip(user_id)`. When we create a new trip with this method, the following will be true:
-   The user ID will be supplied (this is the person requesting a trip)
-   Your code should automatically assign a driver to the trip
 -   For this initial version, choose the first driver whose status is `:AVAILABLE`
-   Your code should use the current time for the start time
-   The end date, cost and rating will all be `nil`
  -   The trip hasn't finished yet!

You should use this information to:

-   Create a new instance of `Trip`
-   Modify this selected driver using a new helper method in `Driver`:
 -Add the new trip to the collection of trips for that `Driver`
    -Set the driver's status to `:UNAVAILABLE`
-   Modify the user for the trip using a new helper method in `User`:
 -Add the new trip to the collection of trips for the `User`
-   Add the new trip to the collection of all `Trip`s in `TripDispatcher`
-   Return the newly created trip

**All of this code must have tests.** Things to pay attention to:
-   Was the trip created properly?
-   Were the trip lists for the driver and user updated?
-   Was the driver who was selected `AVAILABLE`?
-   What happens if you try to request a trip when there are no `AVAILABLE` drivers?

#### Interaction with Waves 1 & 2

One thing you may notice is that this change breaks your code from previous waves, possibly in subtle ways. We've added a new kind of trip, an _in-progress_ trip, that is missing some of the values you need to compute those numbers.

Your code from waves 1 & 2 should _ignore_ any in-progress trips. That is to say, any trip where the end time is `nil` should not be included in your totals.

You should also **add explicit tests** for this new situation. For example, what happens if you attempt to calculate the total money spent for a `User` with an in-progress trip, or the average hourly revenue of a `Driver` with an in-progress trip?

### Wave 4

We want to evolve `TripDispatcher` so it assigns drivers in more intelligent ways. Every time we make a new trip, we want to pick drivers who haven't completed a trip in a long time, or who have never been assigned a trip.

In other words, we should assign the driver to **the available driver who has never driven or lacking a new driver one whose most recent trip ending is the oldest compared to today.**

Modify `TripDispatcher#request_trip` to use the following rules to select a `Driver`:
- The `Driver` must have a status of `AVAILABLE`
- The `Driver` must not have any in-progress trips (end time of `nil`)
- From the `Driver`s that remain, select the one whose most recent trip ended the longest time ago

For example, if we have three drivers, each with two trips:

Driver Name | Status        | Trip 1 end time | Trip 2 end time
---         | ---           | ---             | ---
Ada         | `AVAILABLE`   | Jan 3, 2018     | Jan 9, 2018
Katherine   | `AVAILABLE`   | Jan 1, 2018     | Jan 12, 2018
Grace       | `UNAVAILABLE` | Jan 5, 2018     | `nil`

Grace is excluded because they are not `AVAILABLE`, and because they have one in-progress trip.

Of Ada and Katherine, we prefer Ada, because their most recent trip is older.

**All of this code must have tests.**

## What Instructors Are Looking For
Check out the [feedback template](feedback.md) which lists the items instructors will be looking for as they evaluate your project.
