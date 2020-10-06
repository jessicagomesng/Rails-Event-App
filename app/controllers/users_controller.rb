class UsersController < ApplicationController
    skip_before_action :verified_user, only: [:new, :create]
    before_action :account_redirect, only: [:new]
    before_action :permitted, only: [:index]
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    helper_method :user_has_permission

    def new
        @user = User.new 
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id 
            flash[:message] = "Account created successfully."
            account_redirect 
        else 
            render :New 
        end 
    end 

    def index 
        if params[:event_id]
            @event = Event.find_by_id(params[:event_id])
            @users = @event.users 

            if params[:filter] == "attending"
                @users = @event.attending_users
            elsif params[:filter] == "waiting"
                @users = @event.waiting_users
            end 
        else 
            @users = User.all 
        end
    end 

    def show 
        if @user && (user_has_permission || admin)
        else 
            account_redirect 
        end 
    end

    def edit 
        if @user && user_has_permission 
        else 
            account_redirect
        end 
    end 

    def update 
        @user = current_user    

        if @user.update(user_params)
            flash[:message] = "User info updated successfully."
            redirect_to user_path(@user)
        else 
            render :edit
        end 
    end 

    def destroy 
        if @user && user_has_permission 
            @user.destroy
            flash[:message] = "User successfully deleted."
            redirect_to root_path
        end
    end 

    private 
    def user_params
        params.require(:user).permit(:filter, :first_name, :last_name, :birthday, :email, :password, :password_confirmation)
    end 

    #do I need to add edit params so birthday & email cannot be altered?

    def set_user 
        @user = User.find_by_id(params[:id])
    end

    def user_has_permission
        @user == current_user
    end 
end
