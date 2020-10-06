require 'rails_helper'

RSpec.describe Producer, :type => :model do
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

  it "is valid with a first name, last name, password, password confirmation, and email" do
    expect(producer).to be_valid
  end

  it "is not valid without a first name" do 
    expect(Producer.new(:last_name => "Seller", :email => "jseller@gmail.com", :password => "password", :password_confirmation => "password")).not_to be_valid
  end 

  it "is not valid without a last name" do 
    expect(Producer.new(:first_name => "Jeffrey", :email => "jseller@gmail.com", :password => "password", :password_confirmation => "password")).not_to be_valid
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

#   it "has many rsvps" do
#     first_rsvp = Rsvp.create(:user_id => user.id, :event_id => event.id, :status => "attending")
#     second_rsvp = Rsvp.create(:user_id => user.id, :event_id => event_two.id, :status => "waiting")
#     expect(user.rsvps.first).to eq(first_rsvp)
#     expect(user.rsvps.last).to eq(second_rsvp)
#   end

#   it "has many events through rsvps" do
#     user.events << [event, event_two]
#     expect(user.events.first).to eq(event)
#     expect(user.events.last).to eq(event_two)
#   end

#   it "has a method 'age' that correctly returns the user's age according to their birthday" do 
#     expect(user.age).to eq(30)
#   end 

#   it "has a method 'events_attending' that returns an array of all of the user's attending events" do 
#     Rsvp.create(:user_id => user.id, :event_id => event.id, :status => "attending")
#     expect(user.events_attending.count).to eq(1)
#     expect(user.events_attending.first).to eq(event)
#   end 

#   it "has a method 'events_waiting_for' that returns an array of all of the user's events they are waiting for" do
#     Rsvp.create(:user_id => user.id, :event_id => event_two.id, :status => "waiting")
#     expect(user.events_waiting_for.count).to eq(1)
#     expect(user.events_waiting_for.first).to eq(event_two)
#   end

#   it "has a method 'full_name' that returns the user's full name" do 
#     expect(user.full_name).to eq("Maggie Peluski")
#   end 

end
