class ApplicationController < ActionController::Base

    private 
    def current_user 
        User.find_by_id(session[:user_id]) || Producer.find_by_id(session[:producer_id])
    end 

    def logged_in
        !!current_user 
    end 

    def verified_user 
        redirect_to root_path unless logged_in 
    end 

    def admin 
        current_user.is_a? Producer 
    end 

    def permitted
        redirect_to account_path unless admin 
    end 

    def account_redirect 
        redirect_to account_path if logged_in 
    end 
end
