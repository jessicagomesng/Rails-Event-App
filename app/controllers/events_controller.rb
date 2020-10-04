class EventsController < ApplicationController
    # before_action :permitted, only: [:new, :create, :edit, :update, :destroy]
    before_action :set_event, only: [:show, :edit, :update, :destroy]

    def new 
        if params[:location_id]
            @event = Event.new(:producer_id => session[:producer_id], :location_id => params[:location_id])
        else 
            @event = Event.new(:producer_id => session[:producer_id])
        end 
    end 

    def create 
        @event = Event.new(event_params)

        set_dates

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
            user = User.find_by_id(params[:user_id])
            @events = user.events

            if params[:status] == "attending"
                @events = user.events_attending
            elsif params[:status] == "waiting"
                @events = user.events_waiting
            end 
        else 
            @events = Event.all
        end 

        if params[:filter] == "upcoming"
            @events = @events.upcoming 
        elsif params[:filter] == "past"
            @events = @events.past 
        end 
    end

    def show 
        if !@event 
            flash[:message] = "Sorry, that event cannot be found."
            redirect_to events_path
        else 
            @rsvp = Rsvp.find_or_initialize_by(:event_id => @event.id, :user_id => current_user.id) 
        end 
    end

    def edit 
    end

    def update
        reset_dates 
        set_dates 

        if @event.update(event_params)
            flash[:message] = "Event updated successfully."
            redirect_to event_path(@event)
        else
            render :new 
        end 
    end 

    def destroy 
        @event.destroy
        flash[:message] = "Event deleted."
        redirect_to producer_events_path(current_user)
    end

    private 
    def event_params
        params.require(:event).permit(:filter, :status, :producer_id, :location_id, :name, :price, :image_url, :maximum_capacity, :minimum_age)
    end 

    def set_event
        @event = Event.find_by_id(params[:id])
    end 

    def set_dates 
        if params[:event][:start_date] != ""
            event_start_date = params[:event][:start_date].split("-").collect { |attr| attr.to_i }
            if params[:start_time] != "" 
                event_start_time = params[:start_time].split(":").collect { |attr| attr.to_i }
                set_start_datetime = DateTime.new(event_start_date[0], event_start_date[1], event_start_date[2], event_start_time[0], event_start_time[1])
                @event.assign_attributes(:start_date => set_start_datetime)
            end 
        end
        if params[:event][:end_date] != ""
            event_end_date = params[:event][:end_date].split("-").collect { |attr| attr.to_i }
            if params[:start_time] != "" 
                event_end_time = params[:end_time].split(":").collect { |attr| attr.to_i }
                set_end_datetime = DateTime.new(event_end_date[0], event_end_date[1], event_end_date[2], event_end_time[0], event_end_time[1])
                @event.assign_attributes(:end_date => set_end_datetime)
            end 
        end
    end 

    def reset_dates
        @event.start_date = nil 
        @event.end_date = nil 
    end 
end
