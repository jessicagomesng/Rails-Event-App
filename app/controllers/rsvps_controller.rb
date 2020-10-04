class RsvpsController < ApplicationController
    def create 
        #check this status = nil thing. Is this still setting as soon as the user visits the page? 
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
        Rsvp.find_by_id(params[:id]).destroy 
        flash[:message] = "You have successfully left this event."
        redirect_to user_events_path(current_user)
    end 

    def rsvp_params
        params.require(:rsvp).permit(:user_id, :event_id, :status)
end
