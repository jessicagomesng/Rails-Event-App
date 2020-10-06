require 'rails_helper'

RSpec.describe Rsvp, :type => :model do
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

  let(:underage_user) {
    User.create( 
        first_name: "Jack", 
        last_name: "Jack",
        password: "incredible",
        password_confirmation: "incredible",
        email: "jackjack@theincredibles.com",
        birthday: Date.new(2020, 2, 5)
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
        Event.create(
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

    let(:rsvp_one) { 
        Rsvp.create(
            :event_id => event_one.id,
            :user_id => user.id, 
            :status => "attending"
        )
    }

    let(:rsvp_two) { 
        Rsvp.create(
            :event_id => event_two.id,
            :user_id => user.id, 
            :status => "waiting"
        )
    }

  it "is valid with a user_id, event_id, and status" do
    expect(rsvp_one).to be_valid
  end

  it "belongs to one user" do 
    expect(rsvp_one.user).to eq(user)
  end 

  it "belongs to one event" do 
    expect(rsvp_one.event).to eq(event_one)
  end 

#   it "automatically sets status to 'attending' for events that aren't full" do 
#   end 

#   it "automatically sets status to 'waiting' for events that are full" do
#     expect(rsvp_two.status).to eq("waiting") 
#   end 

  it "is not valid if the user is underage" do 
    expect(underage_rsvp = Rsvp.create(:event_id => event_two.id, :user_id => underage_user.id)).to_not be_valid
    expect(underage_rsvp.errors.full_messages.first).to eq("User must be at least #{event_two.minimum_age} years old to attend this event.")
  end 

  it "has a scope method 'attending' that returns all rsvps for which a user is attending" do 
    rsvp_one = Rsvp.create(
        :event_id => event_one.id,
        :user_id => user.id, 
        :status => "attending"
    )
    expect(Rsvp.attending.count).to eq(1)
    expect(Rsvp.attending.first).to eq(rsvp_one)
  end

  it "has a scope method 'waiting' that returns all rsvps for which a user is waiting" do 
    rsvp_two = Rsvp.create(
        :event_id => event_two.id,
        :user_id => user.id, 
        :status => "waiting"
    )
    expect(Rsvp.waiting.count).to eq(1)
    expect(Rsvp.waiting.first).to eq(rsvp_two)
  end

end
