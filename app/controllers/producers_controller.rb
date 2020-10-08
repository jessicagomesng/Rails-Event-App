class ProducersController < ApplicationController
    skip_before_action :verified_user, only: [:new, :create]
    before_action :account_redirect, only: [:new]
    before_action :set_producer, only: [:show, :edit, :update, :destroy]
    before_action :producer_not_found, only: [:show, :edit]
    helper_method :producer_has_permission
    
    def new 
        @producer = Producer.new 
    end 
    
    def create 
        @producer = Producer.new(producer_params)
        
        if @producer.save 
            session[:producer_id] = @producer.id
            flash[:message] = "Account created successfully."
            redirect_to account_path
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
        account_redirect unless producer_has_permission
    end 

    def update 
        if @producer.update(producer_params)
            flash[:message] = "Profile updated successfully."
            redirect_to producer_path(@producer)
        else 
            render :edit 
        end 
    end 
    
    def destroy 
        if producer_has_permission
            @producer.destroy
            @producer.events.destroy_all
            flash[:message] = "Profile and events successfully deleted."
            redirect_to root_path
        end 
    end 

    private
    def producer_params
        params.require(:producer).permit(:first_name, :last_name, :password, :password_confirmation, :email)
    end 
    
    def set_producer 
        @producer = Producer.find_by_id(params[:id])
    end

    def producer_not_found
        if !@producer 
            flash[:message] = "Sorry, that producer cannot be found."
            redirect_to producers_path 
        end 
    end 

    def producer_has_permission
        @producer == current_user
    end 
end
