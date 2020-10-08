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

