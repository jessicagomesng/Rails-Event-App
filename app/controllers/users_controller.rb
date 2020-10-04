class UsersController < ApplicationController
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
    end

    def edit 
    end 

    def update 
    end 

    def destroy 
    end 

    private 
    def user_params
        params.require(:user).permit(:filter, :first_name, :last_name, :birthday, :email, :password, :password_confirmation)
    end 
end
