class ProducersController < ApplicationController
    before_action :set_producer, only: [:show, :edit, :update, :destroy]
    
    def new 
        @producer = Producer.new 
    end 
    
    def create 
        @producer = Producer.new(producer_params)
        
        if @producer.save 
            session[:producer_id] = @producer.id
            flash[:message] = "Account created successfully."
            account_redirect
        else 
            render :new 
        end 
    end

    def index 
        @producers = Producer.all
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
    def producer_params
        params.require(:producer).permit(:first_name, :last_name, :password, :password_confirmation, :email)
    end 
    
    def set_producer 
        @producer = Producer.find_by_id(params[:id])
    end
end
