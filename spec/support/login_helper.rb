module LoginHelper

    def user_signup
        fill_in("user[first_name]", :with => "Maggie")
        fill_in("user[last_name]", :with => "Peluski")
        fill_in("user[password]", :with => "heythere")
        fill_in("user[password_confirmation]", :with => "heythere")
        fill_in("user[email]", :with => "mpeluski@peluski.com")
        fill_in("user[birthday]", :with => "1990-10-05")
        click_button('Sign Up')
    end

    def underage_user_signup
        fill_in("user[first_name]", :with => "Jack")
        fill_in("user[last_name]", :with => "Jack")
        fill_in("user[password]", :with => "incredible")
        fill_in("user[password_confirmation]", :with => "incredible")
        fill_in("user[email]", :with => "jackjack@theincredibles.com")
        fill_in("user[birthday]", :with => "2020-02-05")
        click_button('Sign Up')
    end 

    def underage_user_login
        fill_in("email", :with => "jackjack@theincredibles.com")
        fill_in("password", :with => "incredible")
        click_button('Sign In')
    end 
  
    def user_login
        fill_in("email", :with => "mpeluski@peluski.com")
        fill_in("password", :with => "heythere")
        click_button('Sign In')
    end
  
    def producer_signup
        fill_in("producer[first_name]", :with => "Jeffrey")
        fill_in("producer[last_name]", :with => "Seller")
        fill_in("producer[password]", :with => "password")
        fill_in("producer[password_confirmation]", :with => "password")
        fill_in("producer[email]", :with => "jseller@gmail.com")
        click_button('Sign Up')
    end
  
    def producer_login
        fill_in("email", :with => "jseller@gmail.com")
        fill_in("password", :with => "password")
        check "producer"
        click_button('Sign In')
    end
  
    def create_standard_user 
      @maggie = User.create(
        first_name: "Maggie", 
        last_name: "Peluski",
        password: "heythere",
        password_confirmation: "heythere",
        email: "mpeluski@peluski.com",
        birthday: Date.new(1990, 10, 5)
        )
    end
  
    def create_standard_producer
      @jeffrey = Producer.create(
        first_name: "Jeffrey",
        last_name: "Seller",
        password: "password",
        password_confirmation: "password", 
        email: "jseller@gmail.com"
      )
    end

    def create_underage_user 
        @jack = User.create(
            first_name: "Jack", 
            last_name: "Jack",
            password: "incredible",
            password_confirmation: "incredible",
            email: "jackjack@theincredibles.com",
            birthday: Date.new(2020, 2, 5)
            )
    end 
    
  end