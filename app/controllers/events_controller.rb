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
end
