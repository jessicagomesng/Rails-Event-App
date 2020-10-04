class ProducersController < ApplicationController
    before_action :set_producer only: [:show, :edit, :update, :destroy]
    
    def new 
        @producer = Producer.new 
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
    def set_producer 
        @producer = Producer.find_by_id(params[:id])
    end 
end
