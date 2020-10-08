require_relative "../rails_helper.rb"
describe 'Feature Test: Producer Signup', :type => :feature do

    it 'successfully signs up as a producer' do
        visit '/producers/new'
        expect(current_path).to eq('/producers/new')
        producer_signup
        expect(current_path).to eq('/account')
        expect(page).to have_text("Welcome to the Event Booker, Jeffrey Seller!")
        expect(page).to have_content("What would you like to do?")
    end

    it "on sign up, successfully adds a session hash" do
        visit '/producers/new'
        producer_signup
        expect(page.get_rack_session_key('producer_id')).to_not be_nil
        expect(page.get_rack_session).to_not include("user_id")
    end

    it 'successfully logs in as a producer' do
        create_standard_producer
        visit '/login'
        expect(current_path).to eq('/login')
        producer_login
        expect(current_path).to eq('/account')
        expect(page).to have_text("Welcome to the Event Booker, Jeffrey Seller!")
        expect(page).to have_content("What would you like to do?")
    end

    it "on log in, successfully adds a session hash" do
        create_standard_producer
        visit '/login'
        producer_login
        expect(page.get_rack_session_key('producer_id')).to_not be_nil
    end

    it 'does not authenticate a producer with the wrong password' do 
        create_standard_producer 
        visit '/login'
        fill_in("email", :with => "jseller@gmail.com")
        fill_in("password", :with => "wrongpassword")
        click_button('Sign In')
        expect(current_path).to eq('/login')
    end 

    it 'prevents producer from viewing the root path and redirects to account page if logged in' do
        create_standard_producer
        visit '/login'
        producer_login
        visit '/'
        expect(current_path).to eq('/account')
    end

    it 'prevents producer from viewing the sign up page and redirects to account page if logged in' do
        create_standard_producer
        visit '/login'
        producer_login
        visit '/producers/new'
        expect(current_path).to eq('/account')
    end
end 

describe 'Feature Test: Producer Signout', :type => :feature do

    it 'has a link to log out from the account page' do
      create_standard_producer
      visit '/login'
      producer_login
      visit '/account'
      expect(page).to have_content("Log Out")
    end

    it 'redirects to home page after logging out' do
        create_standard_producer
        visit '/login'
        producer_login
        click_link("Log Out")
        expect(current_path).to eq('/')
    end

    it "successfully destroys session hash when 'Log Out' is clicked" do
        create_standard_producer
        visit '/login'
        producer_login
        click_link("Log Out")
        expect(page.get_rack_session).to_not include("producer_id")
    end
end 

    describe 'Feature Test: Producer Account', :type => :feature do
        it 'lets a producer view his/her own show page' do
          create_standard_producer
          visit '/login'
          producer_login
          visit '/account'
          click_on 'View Profile'
          expect(page).to have_content("Jeffrey Seller")
        end
    
        it "contains a link to edit/delete if it is the producer's show page" do 
            create_standard_producer
            visit '/login'
            producer_login
            click_on "View Profile"
            expect(page).to have_content("Edit/delete profile")
        end 
    
        it "does not contain a link to edit/delete if someone else is viewing" do 
            create_standard_user
            visit '/login'
            user_login
            @producer = Producer.create(
                first_name: "Jeffrey",
                last_name: "Seller",
                password: "password",
                password_confirmation: "password", 
                email: "jseller@gmail.com"
            )
            visit("/producers/#{@producer.id}")
            expect(page).to_not have_content("Edit/delete profile")
        end
    
        it "lets the producer edit his/her show page" do
            create_standard_producer
            visit '/login'
            producer_login
            click_link 'Edit Profile Info'
            fill_in("producer[first_name]", :with => "Jeffrey")
            fill_in("producer[last_name]", :with => "Changed")
            fill_in("producer[password]", :with => "password")
            fill_in("producer[password_confirmation]", :with => "password")
            click_on "Update Profile"
            expect(page).to have_content("Jeffrey Changed")
        end 
    
        it "does not let the producer edit anyone else's show page" do 
            create_standard_producer
            @scott_producer = Producer.create(
                first_name: "Scott",
                last_name: "Rudin",
                password: "password",
                password_confirmation: "password", 
                email: "srudin@gmail.com"
            )
            visit '/login'
            producer_login
            visit("producers/#{@scott_producer.id}/edit")
            expect(page.current_path).to eq("/account")
            expect(page).to have_content("Sorry, you do not have permission to access this page!")
        end 

        it "edit page lets a producer delete his/her page" do 
            create_standard_producer
            create_standard_user
            visit '/login'
            producer_login
            click_on 'Edit Profile Info'
            click_button "Delete Profile"
            expect(page.current_path).to eq('/')
            expect(page).to have_content('Profile and events successfully deleted.')
            visit('/login')
            user_login
            visit("/producers")
            expect(page).to_not have_content("Jeffrey Seller")
        end 
    end 

    describe 'Feature Test: Producer Events', :type => :feature do
        before :each do
            @producer = Producer.create(
                first_name: "Jeffrey",
                last_name: "Seller",
                password: "password",
                password_confirmation: "password", 
                email: "jseller@gmail.com"
            )

            @producer_two = Producer.create(
                first_name: "Scott",
                last_name: "Rudin",
                password: "password",
                password_confirmation: "password", 
                email: "srudin@gmail.com"
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
                :minimum_age => 1
            )

            @event_two = Event.create(
                :producer_id => @producer_two.id, 
                :location_id => @location.id,
                :name => "New Year's Bash",
                :start_date => DateTime.new(2021, 1, 1),
                :end_date => DateTime.new(2021, 1, 1, 8),
                :price => 300.00,
                :maximum_capacity => 0,
                :minimum_age => 21
            )
    
            @user_one = User.create(
                first_name: "Maggie", 
                last_name: "Peluski",
                password: "heythere",
                password_confirmation: "heythere",
                email: "mpeluski@peluski.com",
                birthday: Date.new(1990, 10, 5)
            )

            @user_two = User.create(
                first_name: "Peety", 
                last_name: "the Pup",
                password: "greatest",
                password_confirmation: "greatest",
                email: "peet@peter.com",
                birthday: Date.new(2000, 12, 17)
            )

            @rsvp_one = Rsvp.create(
                :event_id => @event_one.id,
                :user_id => @user_one.id, 
                :status => "attending"
            )

            @rsvp_two = Rsvp.create(
                :event_id => @event_one.id,
                :user_id => @user_two.id, 
                :status => "waiting"
            )
    
            visit '/login'
            producer_login
        end

        it "allows a producer to create a new event" do 
            click_link "Create a New Event"
            expect(page.current_path).to eq('/events/new')
            expect(page).to have_content("Create a New Event")
        end 

        it "event show page contains a link to edit/delete for the creator of that event" do 
            visit("/events/#{@event_one.id}")
            expect(page).to have_content("Edit/Delete Event")
        end 

        it "event show page does not contain a link to edit/delete if the producer did not create the event" do
            visit("/events/#{@event_two.id}")
            expect(page).to_not have_content("Edit/Delete Event") 
        end 

        it "allows a producer to edit his/her own event" do 
            visit("/events/#{@event_one.id}")
            click_link "Edit/Delete Event"
            fill_in("event[name]", :with => "Second Bash")
            fill_in("start_time", :with => "18:13")
            fill_in("end_time", :with => "20:13")
            click_button "Update Event"
            expect(page.current_path).to eq("/events/#{@event_one.id}")
            expect(page).to have_content("Second Bash")
            expect(page).to_not have_content("Party of a Lifetime")
        end 

        it "allows a producer to delete his/her own event" do 
            visit("/events/#{@event_one.id}")
            click_link "Edit/Delete Event"
            click_button "Delete Event"
            expect(page.current_path).to eq("/producers/#{@producer.id}/events")
            expect(page).to_not have_content("Party of a Lifetime")
        end 

        it "does not allow a producer to edit anyone else's event" do 
            visit("/events/#{@event_two.id}/edit")
            expect(current_path).to eq("/account") 
            expect(page).to have_content("Sorry, you do not have permission to access this page!")
        end 

        it "allows a producer to view all events" do 
            visit("/events")
            expect(page).to have_content("Party of a Lifetime")
            expect(page).to have_content("New Year's Bash")
        end 

        it "allows a producer to view his/her events" do 
            click_link "My Events"
            expect(page).to have_content("Party of a Lifetime")
            expect(page).to_not have_content("New Year's Bash")
        end 

        it "lets a producer view the users attending his/her event" do 
            visit "/events/#{@event_one.id}"
            click_link "See All Users for this Event"
            expect(page.current_path).to eq("/events/#{@event_one.id}/users")
            expect(page).to have_content("Maggie Peluski")
        end 

        it "has an option on the user index page to only view attending users" do 
            visit "/events/#{@event_one.id}"
            click_link "See All Users for this Event"
            expect(page.current_path).to eq("/events/#{@event_one.id}/users")
            expect(page).to have_content("Maggie Peluski")
            expect(page).to have_content("Peety the Pup")
            choose('filter_attending')
            click_button("Filter Results")
            expect(page).to have_content("#{@user_one.full_name}")
            expect(page).to_not have_content("#{@user_two.full_name}")
        end

        it "has an option on the user index page to only view waiting users" do 
            visit "/events/#{@event_one.id}"
            click_link "See All Users for this Event"
            expect(page.current_path).to eq("/events/#{@event_one.id}/users")
            expect(page).to have_content("#{@user_one.full_name}")
            expect(page).to have_content("#{@user_two.full_name}")
            choose('filter_waiting')
            click_button("Filter Results")
            expect(page).to have_content("#{@user_two.full_name}")
            expect(page).to_not have_content("#{@user_one.full_name}")
        end
    end 

    describe 'Feature Test: Location Flow', :type => :feature do
        #can create a location
        #can edit a location
        #can create an event at a location
        #can view a list of locations

    

    it "lets a producer view the users index page" do 
        create_standard_producer
        visit '/login'
        producer_login
        visit '/users'
        expect(current_path).to eq("/users")
        expect(page).to have_content("Users List")
    end 

            #if a producer deletes his/her profile, all of their associated events are also deleted 


end 