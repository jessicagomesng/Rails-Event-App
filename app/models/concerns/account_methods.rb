module AccountMethods
    extend ActiveSupport::Concern

    module InstanceMethods 
        def full_name
            self.first_name + " " + self.last_name 
        end 
    end 

    module ClassMethods 
        def emails
            self.all.collect { |user| user.email.downcase }
        end 
    end 
end 