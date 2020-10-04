class LocationsController < ApplicationController
    before_action :set_location, only: [:show, :edit, :update]
    
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
        @locations = Location.all
    end

    def show 
    end 

    def edit
    end

    def update
    end 

    private 
    def location_params 
        params.require(:location).permit(:name, :address, :maximum_capacity)
    end 

    def set_location
        @location = Location.find_by_id(params[:id])
    end 
end
