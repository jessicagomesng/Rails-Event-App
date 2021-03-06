class ApplicationController < ActionController::Base
    before_action :verified_user
    helper_method :current_user, :admin, :logged_in

    private 
    def current_user 
        User.find_by_id(session[:user_id]) || Producer.find_by_id(session[:producer_id])
    end 

    def logged_in
        !!current_user 
    end 

    def verified_user 
        if !logged_in 
            flash[:message] = "Sorry, you must be logged in to do that!"
            redirect_to root_path
        end 
    end 

    def admin 
        current_user.is_a? Producer 
    end 

    def permitted
        if !admin
            flash[:message] = "Sorry, only producers can access this feature."
            redirect_to account_path 
        end 
    end 

    def account_redirect 
        flash[:message] = "Sorry, you do not have permission to access this page!"
        redirect_to account_path if logged_in 
    end 
end
