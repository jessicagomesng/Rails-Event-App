module EventsHelper
    def author_admin(event)
        event.producer_id == current_user.id 
    end 

    def waiting_list(event)
        event.waiting_count > 0
    end 
end
