class RsvpsController < ApplicationController
    def create 
        rsvp = Rsvp.new(:user_id => current_user.id, :event_id => params[:rsvp][:event_id], :status => nil)
        @event = Event.find_by_id(params[:rsvp][:event_id])
        @user = User.find_by_id(params[:rsvp][:user_id])

        if rsvp.save 
            if @event.full?
                rsvp.update(:status => "waiting")
                flash[:message] = "You have successfully joined the waiting list. You are number #{@user.place_in_line(@event)} in line."
            else
                rsvp.update(:status => "attending")
                flash[:message] = "RSVP successful! You are attending this event."
            end 
            redirect_to user_events_path(@user)
        else 
            @rsvp = rsvp 
            render "events/show"
        end 
    end

    def destroy 
    end 
end
