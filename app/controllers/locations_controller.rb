class LocationsController < ApplicationController
    before_action :permitted, only: [:new, :create, :edit, :update]
    before_action :set_location, only: [:show, :edit, :update]
    before_action :location_not_found, only: [:show, :edit]
    
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
        if @location.update(location_params)
            redirect_to location_path(@location)
        else 
            render :edit 
        end 
    end 

    private 
    def location_params 
        params.require(:location).permit(:name, :address, :maximum_capacity)
    end 

    def set_location
        @location = Location.find_by_id(params[:id])
    end 

    def location_not_found 
        if !@location 
            flash[:message] = "Sorry, that location cannot be found."
            redirect_to locations_path
        end 
    end 
end
