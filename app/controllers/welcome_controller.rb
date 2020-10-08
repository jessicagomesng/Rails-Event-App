class WelcomeController < ApplicationController
    skip_before_action :verified_user, only: [:home]
    
    def home 
        redirect_to account_path unless !logged_in
    end

    def account 
        render :layout => 'application'
    end
end
