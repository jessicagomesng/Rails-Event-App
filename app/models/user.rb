class User < ApplicationRecord
    has_many :rsvps
    has_many :events, through: :rsvps
    has_many :locations, through: :events 

    has_secure_password

    validates :first_name, :last_name, :email, :presence => true 
    validates :birthday, :presence => true, :on => :create
    validates :password_confirmation, :presence => true 
    validates :password, :presence => true, :confirmation => true 

    include AccountMethods::InstanceMethods
    extend AccountMethods::ClassMethods

    includes ActiveModel::Validations 
    validates_with EmailValidator, :on => :create

    def age 
        now = Time.now.utc.to_date 
        dob = self.birthday

        now.year - dob.year - (((now.month - dob.month) > 0 || (now.month >= dob.month && now.day >= dob.day)) ? 0 : 1)
    end 
end
