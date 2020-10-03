module EventsHelper
    def author_admin(event)
        event.producer_id == current_user.id 
    end 
end
