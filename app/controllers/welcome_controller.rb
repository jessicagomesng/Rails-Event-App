class WelcomeController < ApplicationController
    skip_before_action :verified_user, only: [:home]
    before_account :account_redirect, only: [:home]
    
    def home 
    end

    def account 
        render :layout => 'application'
    end
end
