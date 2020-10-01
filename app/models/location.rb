class Location < ApplicationRecord
    has_many :events
    has_many :users, through: :events 
    has_many :producers: through: :events
end
