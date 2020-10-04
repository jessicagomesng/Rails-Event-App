class UserIdValidator < ActiveModel::UserIdValidator
    #validates a user's minimum age before rsvp
    def validate(record)
        event = Event.find_by_id(record.event_id)
        user = User.find_by_id(record.user_id)

        if event.minimum_age && user.age < event.minimum_age 
            record.errors[:user_id] << "must be at least #{event.minimum_age} years old to attend this event."
        end 
    end 
end