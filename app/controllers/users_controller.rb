class UsersController < ApplicationController
    def new
        @user = User.new 
    end

    def create
    end 

    def index 
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
