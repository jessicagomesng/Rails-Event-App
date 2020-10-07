require_relative "../rails_helper.rb"
describe 'Feature Test: User Signup', :type => :feature do

#user and producer can only ecit their own profiles
#producer can edit any location
#producer cannot edit any other events 
#producer can view a list of users for that event
#if not logged in, cannot access: events#show, users#index, users#show, users#edit, events#new, events#edit, locations#index, locations#show, locations#new, locations#edit, producers#show, producers#index, producers#edit, welcome#account
#if not admin, cannot access: user#show, users#edit, users#index, events#new, events#edit, locations#new, locations#edit, producers#edit, 


    it 'successfully signs up as a user' do
        visit '/users/new'
        expect(current_path).to eq('/users/new')
        # user_signup method is defined in login_helper.rb
        user_signup
        expect(current_path).to eq('/account')
        expect(page).to have_text("Welcome to the Event Booker, Maggie Peluski!")
        expect(page).to have_content("What would you like to do?")
    end

    it "on sign up, successfully adds a session hash" do
        visit '/users/new'
        # user_signup method is defined in login_helper.rb
        user_signup
        expect(page.get_rack_session_key('user_id')).to_not be_nil
        expect(page.get_rack_session).to_not include("producer_id")
    end

    it 'successfully logs in as a user' do
        
        # user_login method is defined in login_helper.rb
        create_standard_user
        visit '/login'
        expect(current_path).to eq('/login')
        user_login
        expect(current_path).to eq('/account')
        expect(page).to have_text("Welcome to the Event Booker, Maggie Peluski!")
        expect(page).to have_content("What would you like to do?")
    end

    it "on log in, successfully adds a session hash" do
        create_standard_user
        visit '/login'
        # user_login method is defined in login_helper.rb
        user_login
        expect(page.get_rack_session_key('user_id')).to_not be_nil
    end

    it 'does not authenticate a user with the wrong password' do 
        create_standard_user 
        visit '/login'
        fill_in("email", :with => "mpeluski@peluski.com")
        fill_in("password", :with => "wrongpassword")
        click_button('Sign In')
        expect(current_path).to eq('/login')
    end 

    it 'prevents user from viewing the root path and redirects to account page if logged in' do
        create_standard_user
        visit '/login'
        user_login
        visit '/'
        expect(current_path).to eq('/account')
    end

    it 'prevents user from viewing the sign up page and redirects to account page if logged in' do
        create_standard_user
        visit '/login'
        user_login
        visit '/users/new'
        expect(current_path).to eq('/account')
    end
end 

  describe 'Feature Test: User Signout', :type => :feature do

    it 'has a link to log out from the account page' do
      create_standard_user
      visit '/login'
      user_login
      visit '/account'
      expect(page).to have_content("Log Out")
    end

    it 'redirects to home page after logging out' do
        create_standard_user
        visit '/login'
        # user_signup method is defined in login_helper.rb
        user_login
        click_link("Log Out")
        expect(current_path).to eq('/')
    end

    it "successfully destroys session hash when 'Log Out' is clicked" do
        create_standard_user
        visit '/login'
        # user_signup method is defined in login_helper.rb
        user_login
        click_link("Log Out")
        expect(page.get_rack_session).to_not include("user_id")
    end
end 

describe 'Feature Test: User Show Page', :type => :feature do
    it 'lets a user view his/her own show page' do
      create_standard_user
      visit '/login'
      user_login
      visit '/account'
      click_on 'View Profile'
      expect(page).to have_content("Maggie Peluski")
    end

    it "does not let a user view anyone else's show page" do
        create_standard_user
        create_underage_user
        visit '/login'
        user_login
        visit '/users/2'
        expect(current_path).to eq("/account")
    end
end

describe 'Feature Test: User Index Page', :type => :feature do
    it "does not let a user view the users index page" do
        create_standard_user
        visit '/login'
        user_login
        visit '/users'
        expect(current_path).to eq("/account")
    end
end

describe 'Feature Test: Create Rsvp', :type => :feature do

    before :each do
        @producer = Producer.create(
            first_name: "Jeffrey",
            last_name: "Seller",
            password: "password",
            password_confirmation: "password", 
            email: "jseller@gmail.com"
        )

        @location = Location.create(
            :name => "North Pole",
            :address => "Santa's Workshop, Antarctica",
            :maximum_capacity => 1500
          )

        @event_one = Event.create(
            :producer_id => @producer.id, 
            :location_id => @location.id,
            :name => "Party of a Lifetime",
            :start_date => DateTime.new(2020, 12, 25),
            :end_date => DateTime.new(2020, 12, 25, 23, 59),
            :price => 50.00,
            :maximum_capacity => 1000,
            :minimum_age => 5
        )

        @event_two = Event.create(
            :producer_id => @producer.id, 
            :location_id => @location.id,
            :name => "New Year's Bash",
            :start_date => DateTime.new(2021, 1, 1),
            :end_date => DateTime.new(2021, 1, 1, 8),
            :price => 300.00,
            :maximum_capacity => 0,
            :minimum_age => 21
        )

        @event_three = Event.create(
            :producer_id => @producer.id, 
            :location_id => @location.id,
            :name => "Historic Party",
            :start_date => DateTime.new(2019, 1, 1),
            :end_date => DateTime.new(2019, 1, 1, 8),
            :price => 20.00,
            :maximum_capacity => 0
        )

        @user = User.create(
            first_name: "Maggie", 
            last_name: "Peluski",
            password: "heythere",
            password_confirmation: "heythere",
            email: "mpeluski@peluski.com",
            birthday: Date.new(1990, 10, 5)
        )

        visit '/login'
        user_login
    end

    it 'has a link from the account page to the events index page' do 
        expect(page).to have_content("All Events")
        click_link('All Events')
    end

    it "links from the events index page to the events' show pages" do
        click_link('All Events')
        click_link("#{@event_one.name}")
        expect(current_path).to eq("/events/#{@event_one.id}")
    end

    it "has a link from the account page to all of the user's events they've RSVP'd to" do 
        expect(page).to have_content("My Events")
        visit("/events/#{@event_one.id}")
        click_button 'Yes'
        click_link("My Events")
        expect(page).to have_content("Party of a Lifetime")
    end 

    it "has an option on the user events index page to only view a user's upcoming events" do 
        click_link('All Events')
        click_link("#{@event_one.name}")
        click_button("Yes")
        click_link('All Events')
        click_link("#{@event_three.name}")
        click_button("Yes")
        click_link("My Events")
        expect(page).to have_content("#{@event_one.name}")
        expect(page).to have_content("#{@event_three.name}")
        choose('filter_upcoming')
        click_button("Filter Results")
        expect(page).to have_content("#{@event_one.name}")
        expect(page).to_not have_content("#{@event_three.name}")
    end

    it "has an option on the user events index page to only view a user's past events" do 
        click_link('All Events')
        click_link("#{@event_one.name}")
        click_button("Yes")
        click_link('All Events')
        click_link("#{@event_three.name}")
        click_button("Yes")
        click_link("My Events")
        expect(page).to have_content("#{@event_one.name}")
        expect(page).to have_content("#{@event_three.name}")
        choose('filter_past')
        click_button("Filter Results")
        expect(page).to have_content("#{@event_three.name}")
        expect(page).to_not have_content("#{@event_one.name}")
    end

    it "has an option on the user events index page to view the events a user is attending" do 
        click_link('All Events')
        click_link("#{@event_one.name}")
        click_button("Yes")
        click_link('All Events')
        click_link("#{@event_two.name}")
        click_button("Yes")
        click_link("My Events")
        expect(page).to have_content("#{@event_one.name}")
        expect(page).to have_content("#{@event_two.name}")
        choose('status_attending')
        click_button("Filter Results")
        expect(page).to have_content("#{@event_one.name}")
        expect(page).to_not have_content("#{@event_two.name}")
    end

    it "has an option on the user events index page to view the events a user is waiting for" do 
        click_link('All Events')
        click_link("#{@event_one.name}")
        click_button("Yes")
        click_link('All Events')
        click_link("#{@event_two.name}")
        click_button("Yes")
        click_link("My Events")
        expect(page).to have_content("#{@event_one.name}")
        expect(page).to have_content("#{@event_two.name}")
        choose('status_waiting')
        click_button("Filter Results")
        expect(page).to have_content("#{@event_two.name}")
        expect(page).to_not have_content("#{@event_one.name}")
    end

    it 'prevents users from editing/deleting/adding RSVPs on the index page' do
        click_link('My Events')
        expect(current_path).to eq("/users/#{@user.id}/events")
        expect(page).to_not have_content("edit")
        expect(page).to_not have_content("delete")
    end

    it "has a button on the event show page to allow a user to RSVP" do 
        click_link('All Events')
        click_link("#{@event_one.name}")
        expect(current_path).to eq("/events/#{@event_one.id}")
        expect(page).to have_content("Would you like to attend this event?")
        expect(page).to have_button("Yes")
    end 

    it "has a button on the event show page to allow a user to join the wait list if the event is full" do 
        click_link('All Events')
        click_link("#{@event_two.name}")
        expect(current_path).to eq("/events/#{@event_two.id}")
        expect(page).to have_content("Sorry, this event is full! Would you like to join the waiting list?")
        expect(page).to have_button("Yes")
    end 

    it "tells the user the waiting list size if the event is full" do 
        click_link('All Events')
        click_link("#{@event_two.name}")
        expect(current_path).to eq("/events/#{@event_two.id}")
        expect(page).to have_content("There are currently #{@event_two.waiting_count} users in line.")
    end 

    it "clicking on 'Yes' redirects to the user's events page" do
        click_link('All Events')
        click_link("#{@event_one.name}")
        click_button("Yes")
        expect(current_path).to eq("/users/#{@user.id}/events")
    end

    it "when the user is old enough and the RSVP is successful, it displays a success message" do
        click_link('All Events')
        click_link("#{@event_one.name}")
        click_button("Yes")
        expect(page).to have_content("RSVP successful! You are attending this event.")
        click_link('All Events')
        click_link("#{@event_two.name}")
        click_button("Yes")
        expect(page).to have_content("You have successfully joined the waiting list.")
    end

    it "tells the user his/her place in line when they successfully join a waitlist" do
        click_link('All Events')
        click_link("#{@event_two.name}")
        click_button("Yes")
        expect(page).to have_content("You have successfully joined the waiting list. You are number #{@user.place_in_line(@event_two)} in line.")
    end

    it "when the user is too young, clicking on 'Yes' displays a sorry message" do
        @user.update(:birthday => Date.new(2020, 1, 1))
        click_link('All Events')
        click_link("#{@event_two.name}")
        click_button("Yes")
        expect(page).to have_content("User must be at least #{@event_two.minimum_age} years old to attend this event.")
    end

    it "automatically sets the RSVP status to 'attending' if the event is not full and the user is of age" do
        click_link('All Events')
        click_link("#{@event_one.name}")
        click_button("Yes")
        choose 'status_attending'
        click_button("Filter Results")
        expect(page).to have_content("#{@event_one.name}")
    end 

    it "automatically sets the RSVP status to 'waiting' if the event is not full and the user is of age" do
        click_link('All Events')
        click_link("#{@event_two.name}")
        click_button("Yes")
        choose 'status_waiting'
        click_button("Filter Results")
        expect(page).to have_content("#{@event_two.name}")
    end 

    it "allows the user to remove their RSVP if they have already RSVP'd" do 
        click_link('All Events')
        click_link("#{@event_one.name}")
        click_button("Yes")
        expect(page).to have_content("#{@event_one.name}")
        click_link("#{@event_one.name}")
        expect(page).to have_content("You are already attending this event.")
        expect(page).to have_content("Would you like to remove your RSVP/waitlist request?")
        click_button("Yes")
        expect(current_path).to eq("/users/#{@user.id}/events")
        expect(page).to_not have_content("#{@event_one.name}")
    end 

    it "tells the user their place in line if they are waiting and allows them to remove their RSVP" do 
        click_link('All Events')
        click_link("#{@event_two.name}")
        click_button("Yes")
        expect(page).to have_content("#{@event_two.name}")
        click_link("#{@event_two.name}")
        expect(page).to have_content("You are number #{@user.place_in_line(@event_two)} on the waitlist.")
        expect(page).to have_content("Would you like to remove your RSVP/waitlist request?")
        click_button("Yes")
        expect(current_path).to eq("/users/#{@user.id}/events")
        expect(page).to_not have_content("#{@event_two.name}")
    end 
end  

# describe 'Feature Test: Admin Flow', :type => :feature do

#   before :each do
#     @rollercoaster = Attraction.create(
#       :name => "Roller Coaster",
#       :tickets => 5,
#       :nausea_rating => 2,
#       :happiness_rating => 4,
#       :min_height => 32
#     )
#     @ferriswheel = Attraction.create(
#       :name => "Ferris Wheel",
#       :tickets => 2,
#       :nausea_rating => 2,
#       :happiness_rating => 1,
#       :min_height => 28
#     )
#     @teacups = Attraction.create(
#       :name => "Teacups",
#       :tickets => 1,
#       :nausea_rating => 5,
#       :happiness_rating => 1,
#       :min_height => 28
#     )
#     visit '/users/new'
#     admin_signup
#   end

#   it 'displays admin when logged in as an admin on user show page' do
#     expect(page).to have_content("ADMIN")
#   end

#   it 'links to the attractions from the users show page when logged in as a admin' do
#     expect(page).to have_content("See attractions")
#   end

#   it 'has a link from the user show page to the attractions index page when in admin mode' do
#     click_link('See attractions')
#     expect(page).to have_content("#{@teacups.name}")
#     expect(page).to have_content("#{@rollercoaster.name}")
#     expect(page).to have_content("#{@ferriswheel.name}")
#   end

#   it 'allows admins to add an attraction from the index page' do
#     click_link('See attractions')
#     expect(page).to have_content("New Attraction")
#   end

#   it 'allows admins to add an attraction' do
#     click_link('See attractions')
#     click_link("New Attraction")
#     expect(current_path).to eq('/attractions/new')
#     fill_in("attraction[name]", :with => "Haunted Mansion")
#     fill_in("attraction[min_height]", :with => "32")
#     fill_in("attraction[happiness_rating]", :with => "2")
#     fill_in("attraction[nausea_rating]", :with => "1")
#     fill_in("attraction[tickets]", :with => "4")
#     click_button('Create Attraction')
#     expect(current_path).to eq("/attractions/4")
#     expect(page).to have_content("Haunted Mansion")
#   end

#   it "has link to attraction/show from attraction/index page for admins" do
#     click_link('See attractions')
#     expect(page).to have_content("Show #{@ferriswheel.name}")
#   end

#   it "does not suggest that admins go on a ride" do
#     click_link('See attractions')
#     expect(page).to_not have_content("Go on #{@ferriswheel.name}")
#   end

#   it "links to attractions/show page from attractions/index" do
#     click_link('See attractions')
#     click_link("Show #{@rollercoaster.name}")
#     expect(current_path).to eq("/attractions/1")
#   end

#   it "does not suggest that an admin go on a ride from attractions/show page" do
#     click_link('See attractions')
#     click_link("Show #{@rollercoaster.name}")
#     expect(page).to_not have_content("Go on this ride")
#   end

#   it "has a link for admin to edit attraction from the attractions/show page" do
#     click_link('See attractions')
#     click_link("Show #{@rollercoaster.name}")
#     expect(page).to have_content("Edit Attraction")
#   end

#   it "links to attraction/edit page from attraction/show page when logged in as an admin" do
#     click_link('See attractions')
#     click_link("Show #{@rollercoaster.name}")
#     click_link("Edit Attraction")
#     expect(current_path).to eq("/attractions/1/edit")
#   end

#   it "updates an attraction when an admin edits it" do
#     click_link('See attractions')
#     click_link("Show #{@rollercoaster.name}")
#     click_link("Edit Attraction")
#     fill_in("attraction[name]", :with => "Nitro")
#     click_button("Update Attraction")
#     expect(current_path).to eq("/attractions/1")
#     expect(page).to have_content("Nitro")
#   end

