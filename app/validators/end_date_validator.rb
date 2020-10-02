class EndDateValidator < ActiveModel::Validator 
    def validate(record)
        if record.start_date && record.end_date 
            if record.end_date < record.start_date 
            record.errors[:end_date] << "must be later than the event's start date."
            end 
        end 
    end 
end 