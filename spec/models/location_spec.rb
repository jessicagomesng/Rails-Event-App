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

  let(:producer_two) {
    Producer.create(
        first_name: "Scott",
        last_name: "Rudin",
        password: "password",
        password_confirmation: "password", 
        email: "srudin@gmail.com"
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
            :producer_id => producer_two.id, 
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

  it "is not valid without a maximum capacity" do
    expect(Location.create(
        :name => "North Pole",
        :address => "Santa's Workshop, Antarctica",
      )).not_to be_valid
  end

  it "is not valid without a unique address" do
    Location.create(
        :name => "North Pole",
        :address => "Santa's Workshop, Antarctica",
        :maximum_capacity => 1500
      )    
    expect(Location.new(:name => "Elf Village", :address => "Santa's Workshop, Antarctica", :maximum_capacity => 1000)).not_to be_valid
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
    
    expect(location.events.first).to eq(event_one)
    expect(location.events.last).to eq(event_two)
  end 

  it "has many users through events" do 
    event.users << user 
    location.events << event
    expect(location.users.first).to eq(user)
  end 

  it "has many producers through events" do 
    location.events << [event, event_two]
    expect(location.producers.first).to eq(producer)
    expect(location.producers.last).to eq(producer_two)
  end 
end
