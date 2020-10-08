class UsersController < ApplicationController
    skip_before_action :verified_user, only: [:new, :create]
    before_action :account_redirect, only: [:new]
    before_action :permitted, only: [:index]
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :user_not_found, only: [:show, :edit]
    helper_method :user_has_permission

    def new
        @user = User.new 
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id 
            flash[:message] = "Account created successfully."
            redirect_to account_path
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
        account_redirect unless (admin || user_has_permission)
    end

    def edit 
        account_redirect unless user_has_permission
    end 

    def update 
        if @user.update(edit_params)
            flash[:message] = "User info updated successfully."
            redirect_to user_path(@user)
        else 
            render :edit
        end 
    end 

    def destroy 
        if user_has_permission 
            @user.destroy
            flash[:message] = "User successfully deleted."
            redirect_to root_path
        end
    end 

    private 
    def user_params
        params.require(:user).permit(:filter, :first_name, :last_name, :birthday, :email, :password, :password_confirmation)
    end 

    def edit_params
        params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation)
    end 

    def set_user 
        @user = User.find_by_id(params[:id])
    end

    def user_not_found 
        if !@user 
            flash[:message] = "Sorry, that user cannot be found."
            redirect_to users_path  
        end 
    end 

    def user_has_permission
        @user == current_user
    end 
end
