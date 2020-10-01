class Producer < ApplicationRecord
    has_many :events
    has_many :locations, through: :events 
    has_many :comments

    has_secure_password

    validates :first_name, :last_name, :email, :password, :password_confirmation, presence: true 
    validates :password, confirmation: true 

    include AccountMethods::InstanceMethods
    extend AccountMethods::ClassMethods
end
