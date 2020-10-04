class WelcomeController < ApplicationController
    def home 
    end

    def account 
        render :layout => 'application'
    end
end
