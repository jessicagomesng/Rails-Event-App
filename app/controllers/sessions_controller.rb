class SessionsController < ApplicationController
    skip_before_action :verified_user, only: [:new, :create, :omniauth_user]
    before_action :account_redirect, only: [:new]
    
    def new 
    end 

    def create 
        if params[:producer]
            account_holder = Producer.find_by(:email => params[:email])
        else 
            account_holder = User.find_by(:email => params[:email])
        end 

        if account_holder && account_holder.authenticate(params[:password])
            session[(account_holder.class.name.downcase + "_id").to_sym] = account_holder.id
            flash[:message] = "Successfully logged in!"
            account_redirect
        else 
            flash[:message] = "Please try again."
            redirect_to login_path  
        end
    end 

    def omniauth_user 
        @user = User.from_omniauth(auth)
        session[:user_id] = @user.id 
        redirect_to account_path 
    end

    def destroy 
        if admin 
            session.delete("producer_id")
        else 
            session.delete("user_id")
        end 
        
        flash[:message] = "Logout successful."
        redirect_to root_path
    end
    
    private 
    def auth 
        request.env['omniauth.auth']
    end 
end
