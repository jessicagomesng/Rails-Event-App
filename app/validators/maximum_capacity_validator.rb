class MaximumCapacityValidator < ActiveModel::Validator 
    def validate(record)
        if record.location_id && record.maximum_capacity 
            location = Location.find_by_id(record.location_id)

            if location.maximum_capacity < record.maximum_capacity
                record.errors[:maximum_capacity] << "exceeds the location's maximum capacity."
            end 
        end 
    end 
end 