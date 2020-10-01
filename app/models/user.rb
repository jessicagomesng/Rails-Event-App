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
end
