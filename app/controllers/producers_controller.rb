class ProducersController < ApplicationController
    before_action :set_producer, only: [:show, :edit, :update, :destroy]
    helper_method :producer_has_permission
    
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
        if !producer_has_permission
            account_redirect 
            flash[:message] = "Sorry, you do not have permission to access this page!" #dry this
        end 
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
        @producer.destroy
        @producer.events.destroy_all
        flash[:message] = "Profile and events successfully deleted."
        redirect_to root_path
    end 

    private
    def producer_params
        params.require(:producer).permit(:first_name, :last_name, :password, :password_confirmation, :email)
    end 
    
    def set_producer 
        @producer = Producer.find_by_id(params[:id])
    end

    def producer_has_permission
        @producer == current_user
    end 
end
