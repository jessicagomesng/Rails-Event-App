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

        set_start_date
        set_end_date 

        if @event.save 
            flash[:message] = "Event created successfully."
            redirect_to event_path(@event)
        else
            render :new 
        end 
    end 

    def index 
        if params[:location_id]
            @events = Location.find_by_id(params[:location_id]).events 
        elsif params[:producer_id]
            @events = Producer.find_by_id(params[:producer_id]).events
        elsif params[:user_id]
            @events = User.find_by_id(params[:user_id]).events

            if params[:status] == "attending"
                # @events = @events.attending
            elsif params[:status] == "waiting"
                # @events = @events.waiting 
            end 

        else 
            @events = Event.all

            if params[:filter] == "upcoming"
                @events = @events.upcoming 
            elsif params[:filter] == "past"
                @events = @events.past 
            end 
        end 
    end

    def show 
        @users_event = UsersEvent.find_or_initialize_by(:event_id => @event.id, :user_id => current_user.id) 
        
        if !@event 
            redirect_to events_path
            flash[:message] = "Sorry, that event cannot be found."
        end 
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

    def set_start_date 
        if params[:event][:start_date] != ""
            event_start_date = params[:event][:start_date].split("-").collect { |attr| attr.to_i }
            if params[:start_time] != "" 
                event_start_time = params[:start_time].split(":").collect { |attr| attr.to_i }
                set_start_datetime = DateTime.new(event_start_date[0], event_start_date[1], event_start_date[2], event_start_time[0], event_start_time[1])
                @event.assign_attributes(:start_date => set_start_datetime)
            end 
        end
    end 

    def set_end_date
        if params[:event][:end_date] != ""
            event_end_date = params[:event][:end_date].split("-").collect { |attr| attr.to_i }
            if params[:start_time] != "" 
                event_end_time = params[:end_time].split(":").collect { |attr| attr.to_i }
                set_end_datetime = DateTime.new(event_end_date[0], event_end_date[1], event_end_date[2], event_end_time[0], event_end_time[1])
                @event.assign_attributes(:end_date => set_end_datetime)
            end 
        end
    end 
end
