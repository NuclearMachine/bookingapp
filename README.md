# Booking App API

This project was created for Hometime's skill assessment.

Getting Started
----------------------
##### Make sure you have Ruby 3.1.0

##### Bundle the Gemfile

```shell
bundle install
```

##### Create and build the database.

```shell
rails db:create
rails db:migrate
```

#### Start the server!

```shell
rails s
```

Notes for the reviewer
----------------------

The API endpoint is in `/reservations`

You should be able to create and update reservations.

Guest email, name and phone numbers cannot be updated due to instruction 5.

When updating a reservation, always append the reservation code.
