class Producer < ApplicationRecord
    has_many :events
    has_many :locations, through: :events 
    has_many :comments

    has_secure_password
end
