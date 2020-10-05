class WelcomeController < ApplicationController
    skip_before_action :verified_user, only: [:home]
    
    def home 
        if logged_in 
            redirect_to account_path 
        end
    end

    def account 
        render :layout => 'application'
    end
end
