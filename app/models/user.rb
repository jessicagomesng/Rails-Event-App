class User < ApplicationRecord
    has_many :rsvps
    has_many :events, through: :rsvps
    has_many :locations, through: :events 

    has_secure_password
end
