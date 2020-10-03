# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

locations = Location.create([
    { :name => "Esplanade", :address => "1 Esplanade Drive, Singapore, 038981", :maximum_capacity => 1500 },
    { :name => "Savoy Theatre", :address => "Savoy Ct, London WC2R 0ET", :maximum_capacity => 1158 },
    { :name => "London Palladium", :address => "8 Argyll St, Soho, London W1F 7TF", :maximum_capacity => 2286 } ])

producers = Producer.create([
    { :first_name => "Trafalgar", :last_name => "Entertainment", :email => "trafalgarent@trafalgar.com", :password => "HeyThere", :password_confirmation => "HeyThere" },
    { :first_name => "Jeanine", :last_name => "Tesori", :email => "jtesori@gmail.com", :password => "Sunday", :password_confirmation => "Sunday" }
])

events = Event.create([ 
    { 
        :producer_id => 2, 
        :location_id => 2, 
        :name => "Sunday in the Park with George", 
        :price => 200.25, 
        :start_date => DateTime.new(21, 6, 27, 19, 30), 
        :end_date => DateTime.new(21, 6, 27, 22, 30),
        :maximum_capacity => 1100 }, 
    { 
        :producer_id => 2, 
        :location_id => 2, 
        :name => "Miss Saigon", 
        :price => 150.00, 
        :start_date => DateTime.new(21, 7, 8, 19, 30), 
        :end_date => DateTime.new(21, 7, 8, 22, 30),
        :maximum_capacity => 1000,
        :minimum_age => 10 } 
])

users = User.create([
    { :first_name => "Peety", :last_name => "Pie", :email => "peetypie@gmail.com", :birthday => 2021-16-02, :password => "hello", :password_confirmation => "hello" },
    { :first_name => "Chris", :last_name => "Anthony", :email => "canthony@gmail.com", :birthday => 1983-07-01, :password => "testing", :password_confirmation => "testing" },
    { :first_name => "Jess", :last_name => "Peluso", :email => "jesspeluso@gmail.com", :birthday => 1995-10-18, :password => "creator", :password_confirmation => "creator" },
])
