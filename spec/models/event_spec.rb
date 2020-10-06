require 'rails_helper'

RSpec.describe Event, :type => :model do
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

  let(:user_two) {
    User.create(
        first_name: "Peety", 
        last_name: "the Pup",
        password: "greatest",
        password_confirmation: "greatest",
        email: "peet@peter.com",
        birthday: Date.new(2000, 12, 17)
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

  let(:event_one) {
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

  it "is valid with a producer ID, location ID, name, price, start date, end date, and maximum capacity" do
    expect(event_one).to be_valid
  end

    it "is not valid without a producer ID" do 
        expect(Event.create(
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25),
            :end_date => DateTime.new(2020, 12, 25, 23, 59),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)).not_to be_valid
    end 

    it "is not valid without a location ID" do 
        expect(Event.create(
            :producer_id => producer.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25),
            :end_date => DateTime.new(2020, 12, 25, 23, 59),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)).not_to be_valid
    end 

    it "is not valid without a start date" do 
        expect(Event.create(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :end_date => DateTime.new(2020, 12, 25, 23, 59),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)).not_to be_valid
    end 

    it "is not valid without an end date" do 
        expect(Event.create(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)).not_to be_valid
    end 

    it "is not valid without a price" do 
        expect(Event.create(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25),
            :end_date => DateTime.new(2020, 12, 25, 23, 59),
            :maximum_capacity => 1000,
            :minimum_age => 5)).not_to be_valid
    end 

    it "is not valid without a  maximum capacity" do 
        expect(Event.create(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25),
            :end_date => DateTime.new(2020, 12, 25, 23, 59),
            :price => 50.00,
            :minimum_age => 5)).not_to be_valid
    end 

    it "is not valid if the start date is after the end date" do 
        expect(failed_event = Event.create(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25, 23),
            :end_date => DateTime.new(2020, 12, 25, 8),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)).not_to be_valid
        expect(failed_event.errors.full_messages.first).to eq("End date must be later than the event's start date.")
    end 

    it "is not valid if the event's max capacity exceeds that of the location" do 
        expect(failed_event = Event.create(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25),
            :end_date => DateTime.new(2020, 12, 25, 23, 59),
            :price => 50.00,
            :maximum_capacity => 2000,
            :minimum_age => 5)).not_to be_valid
        expect(failed_event.errors.full_messages.first).to eq("Maximum capacity exceeds the location's maximum capacity of #{location.maximum_capacity}.")
    end 

    it "is not valid if the location is already occupied" do 
        event = Event.create(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25),
            :end_date => DateTime.new(2020, 12, 25, 23, 59),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)
        
        failed_event_one = Event.new(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Test One",
            :start_date => DateTime.new(2020, 12, 24, 23),
            :end_date => DateTime.new(2020, 12, 25, 15, 30),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)
            
        failed_event_two = Event.new(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Test Two",
            :start_date => DateTime.new(2020, 12, 25, 12),
            :end_date => DateTime.new(2020, 12, 25, 15, 30),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)

        failed_event_three = Event.new(
            :producer_id => producer.id,
            :location_id => location.id,
            :name => "Test Three",
            :start_date => DateTime.new(2020, 12, 24, 23),
            :end_date => DateTime.new(2020, 12, 26, 19, 30),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5)    
        
        expect(failed_event_one).to_not be_valid 
        expect(failed_event_two).to_not be_valid 
        expect(failed_event_three).to_not be_valid 
        expect(failed_event_one.errors.full_messages.first).to eq("Location is already occupied from #{event.start_date.strftime("%B %e, %Y at %H:%M")} to #{event.end_date.strftime("%B %e, %Y at %H:%M")} by #{event.name}.")
        expect(failed_event_two.errors.full_messages.first).to eq("Location is already occupied from #{event.start_date.strftime("%B %e, %Y at %H:%M")} to #{event.end_date.strftime("%B %e, %Y at %H:%M")} by #{event.name}.")
        expect(failed_event_three.errors.full_messages.first).to eq("Location is already occupied from #{event.start_date.strftime("%B %e, %Y at %H:%M")} to #{event.end_date.strftime("%B %e, %Y at %H:%M")} by #{event.name}.")
    end 

    it "has a scope method 'upcoming' that returns all upcoming events" do 
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
        
        expect(Event.upcoming.count).to eq(2)
        expect(Event.upcoming.first).to eq(event_one)
        expect(Event.upcoming.last).to eq(event_two)
    end

    it "has a scope method 'past' that returns all upcoming events" do 
        event = Event.create(
            :producer_id => producer.id, 
            :location_id => location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 7, 25),
            :end_date => DateTime.new(2020, 7, 25, 13, 00),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5
        )
        
        expect(Event.past.count).to eq(1)
        expect(Event.past.first).to eq(event)
    end

    it "has a method 'attending users' that returns an array of all of the attending users" do
        rsvp_one = Rsvp.create(
            :event_id => event_one.id,
            :user_id => user.id, 
            :status => "attending"
        )
        expect(event_one.attending_users.count).to eq(1)
        expect(event_one.attending_users.first).to eq(user)
    end

    it "has a method 'waiting users' that returns an array of all of the attending users" do
        rsvp_two = Rsvp.create(
            :event_id => event_two.id,
            :user_id => user.id, 
            :status => "waiting"
        )
        expect(event_two.waiting_users.count).to eq(1)
        expect(event_two.waiting_users.first).to eq(user)
    end

    it "has a method 'attendance count' that counts all attending users" do 
        rsvp_one = Rsvp.create(
            :event_id => event_one.id,
            :user_id => user.id, 
            :status => "attending"
        )
        expect(event_one.attendance_count).to eq(1)
    end 

    it "has a method 'waiting count' that counts all waiting users" do 
        rsvp_two = Rsvp.create(
            :event_id => event_two.id,
            :user_id => user.id, 
            :status => "waiting"
        )
        expect(event_two.waiting_count).to eq(1)
    end 
    
    it "has a method 'full?' that returns true/false if the event is full/not full" do 
        expect(event_one.full?).to be_falsey
        expect(event_two.full?).to be_truthy
    end 

    it "has many rsvps" do
        first_rsvp = Rsvp.create(:user_id => user.id, :event_id => event_one.id, :status => "attending")
        second_rsvp = Rsvp.create(:user_id => user_two.id, :event_id => event_one.id, :status => "attending")
        expect(event_one.rsvps.count).to eq(2)
        expect(event_one.rsvps.first).to eq(first_rsvp)
        expect(event_one.rsvps.last).to eq(second_rsvp)
      end

    it "has many users through rsvps" do 
        first_rsvp = Rsvp.create(:user_id => user.id, :event_id => event_one.id, :status => "attending")
        second_rsvp = Rsvp.create(:user_id => user_two.id, :event_id => event_one.id, :status => "attending")

        expect(event_one.users.count).to eq(2)
        expect(event_one.users.first).to eq(user)
        expect(event_one.users.last).to eq(user_two)
    end 

    it "belongs to one producer" do 
        expect(event_one.producer).to eq(producer)
      end 
    
      it "belongs to one location" do 
        expect(event_one.location).to eq(location)
      end 
end
