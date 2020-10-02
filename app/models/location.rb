class Location < ApplicationRecord
    has_many :events
    has_many :users, through: :events 
    has_many :producers, through: :events

    validates :name, :address, :maximum_capacity, presence: true 
    validates :address, uniqueness: true, case_sensitive: false
end
