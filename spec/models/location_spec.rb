require 'rails_helper'

RSpec.describe Location, :type => :model do
  let(:user) {
    User.create(
        first_name: "Maggie", 
        last_name: "Peluski",
        password: "heythere",
        password_confirmation: "heythere",
        email: "mpeluski@peluski.com",
        birthday: Date.new(1990, 10, 5)
    )
  }

  let(:producer) {
    Producer.create(
        first_name: "Jeffrey",
        last_name: "Seller",
        password: "password",
        password_confirmation: "password", 
        email: "jseller@gmail.com"
    )
  }

  let(:location) {
    Location.create(
      :name => "North Pole",
      :address => "Santa's Workshop, Antarctica",
      :maximum_capacity => 1500
    )
  }

  let(:event) {
    Event.create(
        :producer_id => producer.id, 
        :location_id => location.id,
        :name => "Party of a Lifetime",
        :start_date => DateTime.new(2020, 12, 25),
        :end_date => DateTime.new(2020, 12, 25, 23, 59),
        :price => 50.00,
        :maximum_capacity => 1000,
        :minimum_age => 5
    )
    }

    let(:event_two) {
        event = Event.create(
            :producer_id => producer.id, 
            :location_id => location.id,
            :name => "New Year's Bash",
            :start_date => DateTime.new(2021, 1, 1),
            :end_date => DateTime.new(2021, 1, 1, 8),
            :price => 300.00,
            :maximum_capacity => 0,
            :minimum_age => 21
        )
    }

  it "is valid with a name, address, and maximum capacity" do
    expect(location).to be_valid
  end

  it "is not valid without a name" do 
    expect(Location.create(
        :address => "Santa's Workshop, Antarctica",
        :maximum_capacity => 1500
      )).not_to be_valid
  end 

  it "is not valid without an address" do 
    expect(Location.create(
        :name => "North Pole",
        :maximum_capacity => 1500
      )).not_to be_valid
  end 

  it "is not valid without a password" do
    expect(Producer.new(:first_name => "Jeffrey", :last_name => "Seller", :email => "jseller@gmail.com", :password_confirmation => "password")).not_to be_valid
  end

  it "is not valid without an email" do
    expect(Producer.new(:first_name => "Jeffrey", :last_name => "Seller", :password => "password", :password_confirmation => "password")).not_to be_valid
  end

  it "is not valid without a unique email" do
    Producer.create(first_name: "Jeffrey", last_name: "Seller", password: "password", password_confirmation: "password", email: "jseller@gmail.com")
    User.create(first_name: "Maggie", last_name: "Peluski", password: "heythere", password_confirmation: "heythere", email: "mpeluski@peluski.com", birthday: Date.new(1990, 10, 5))
    expect(Producer.new(:first_name => "Scott", :last_name => "Rudin", :email => "jseller@gmail.com", :password => "password", :password_confirmation => "password")).not_to be_valid
    expect(Producer.new(:first_name => "Scott", :last_name => "Rudin", :email => "mpeluski@peluski.com", :password => "password", :password_confirmation => "password")).not_to be_valid
  end

  it "has many events" do 
    event_one = Event.create(
        :producer_id => producer.id, 
        :location_id => location.id,
        :name => "Party of a Lifetime",
        :start_date => DateTime.new(2020, 12, 25),
        :end_date => DateTime.new(2020, 12, 25, 23, 59),
        :price => 50.00,
        :maximum_capacity => 1000,
        :minimum_age => 5
    )
    event_two = Event.create(
            :producer_id => producer.id, 
            :location_id => location.id,
            :name => "New Year's Bash",
            :start_date => DateTime.new(2021, 1, 1),
            :end_date => DateTime.new(2021, 1, 1, 8),
            :price => 300.00,
            :maximum_capacity => 0,
            :minimum_age => 21
        )
    
    expect(producer.events.first).to eq(event_one)
    expect(producer.events.last).to eq(event_two)
  end 

  it "has many locations through events" do 
    producer.events << [event, event_two]
    expect(producer.locations.first).to eq(location)
  end 

  it "has a method 'full_name' that returns the producer's full name" do 
    expect(producer.full_name).to eq("Jeffrey Seller")
  end 

end
