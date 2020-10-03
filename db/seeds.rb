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
    { :first_name => "Trafalgar", :last_name => "Entertainment", :username => "trafalgarent", :email => "trafalgar@trafalgar.com", :password => "ImRich", :password_confirmation => "ImRich" },
    { :first_name => "Jeanine", :last_name => "Tesori", :username => "jtesori", :email => "jtesori@gmail.com", :password => "Sunday", :password_confirmation => "Sunday" }
])

