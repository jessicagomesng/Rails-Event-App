class LocationsController < ApplicationController
    
    def new
        @location = Location.new
    end 

    def create 
        @location = Location.new(location_params)

        if @location.save
            redirect_to location_path(@location)
        else 
            render :new 
        end 
    end 

    def index 
    end

    def show 
    end 

    def edit
    end

    def update
    end 
end
