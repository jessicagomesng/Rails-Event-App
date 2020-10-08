require_relative "../rails_helper.rb"
describe 'Feature Test: Producer Signup', :type => :feature do

#can only see their own show page 
#welcome#account shows appropriate user info 
#user and producer can only ecit their own profiles
#producer can edit any location
#producer cannot edit any other events 
#producer can view a list of users for that event
#user can view a list of events and filter by attending/waiting
#if not logged in, cannot access: events#show, users#index, users#show, users#edit, events#new, events#edit, locations#index, locations#show, locations#new, locations#edit, producers#show, producers#index, producers#edit, welcome#account
#if not admin, cannot access: user#show, users#edit, users#index, events#new, events#edit, locations#new, locations#edit, producers#edit, 


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

    describe 'Feature Test: Producer Show Page', :type => :feature do
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
            click_on 'Edit Profile Info'
            fill_in("producer[first_name]", :with => "Jeffrey")
            fill_in("producer[last_name]", :with => "Changed")
            fill_in("producer[password]", :with => "password")
            fill_in("producer[password_confirmation]", :with => "password")
            click_on "Update Profile"
            expect(page).to have_content("Jeffrey Changed")
        end 
    
        it "does not let the user edit anyone else's show page" do 
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
        #can delete
        #if a producer deletes his/her profile, all of their associated events are also deleted 
    end


