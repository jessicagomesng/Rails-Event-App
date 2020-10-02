class LocationIdValidator < ActiveModel::Validator 
    def validate(record)
        if record.location_id
            location = Location.find_by_id(record.location_id)
            if record.start_date && record.end_date 
                start_date_array = record.start_date.to_s.gsub(/[-:\s]/, ",").split(",").collect { |attr| attr.to_i }
                end_date_array = record.end_date.to_s.gsub(/[-:\s]/, ",").split(",").collect { |attr| attr.to_i }
                event_start = DateTime.new(start_date_array[0], start_date_array[1], start_date_array[2], start_date_array[3], start_date_array[4])
                event_finish = DateTime.new(end_date_array[0], end_date_array[1], end_date_array[2], end_date_array[3], end_date_array[4])


    #still needs checked -- will update time but will not update date if time is not present. 
        def validate(record)
            if record.location_id
                location = Location.find_by_id(record.location_id)
                
                if record.start_date && record.end_date 
                    start_date_array = record.start_date.to_s.gsub(/[-:\s]/, ",").split(",").collect { |attr| attr.to_i }
                    end_date_array = record.end_date.to_s.gsub(/[-:\s]/, ",").split(",").collect { |attr| attr.to_i }
                    start = DateTime.new(start_date_array[0], start_date_array[1], start_date_array[2], start_date_array[3], start_date_array[4])
                    finish = DateTime.new(end_date_array[0], end_date_array[1], end_date_array[2], end_date_array[3], end_date_array[4])
    
                    occupying_event = location.events.detect { |event|
                            (start < event.start_date && finish > event.end_date) || start.between?(event.start_date, event.end_date) ||  finish.between?(event.start_date, event.end_date) } 
                            
                    if occupying_event && occupying_event.name != record.name 
                        record.errors[:location_id] << "is already occupied from #{occupying_event.start_date} to #{occupying_event.end_date} by #{occupying_event.name}." 
                    end 
                end 
            end 
        end 
end 