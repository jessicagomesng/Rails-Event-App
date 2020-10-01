class EmailValidator < ActiveModel::Validator 
    def validate(record)
        if record.email && (User.emails.include?(record.email.downcase) || Producer.emails.include?(record.email.downcase))
            record.errors[:email] << 'is already associated with an account.'
        end 
    end 
end 