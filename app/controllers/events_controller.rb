class EventsController < ApplicationController
    # before_action :permitted, only: [:new, :create, :edit, :update, :destroy]
    # before_action :set_event, only: [:show, :edit, :update, :destroy]

    def new 
        if params[:location_id]
            @event = Event.new(:producer_id => session[:producer_id], :location_id => params[:location_id])
        else 
            @event = Event.new(:producer_id => session[:producer_id])
        end 
    end 

    def create 
        @event = Event.new(event_params)

        if @event.save 
            flash[:message] = "Event created successfully."
            redirect_to event_path(@event)
        else
            render :new 
        end 
    end 

    def index 
        @events = Event.all
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
    def event_params
        params.require(:event).permit(:filter, :status, :producer_id, :location_id, :name, :price, :image_url, :maximum_capacity, :minimum_age)
    end 
end
