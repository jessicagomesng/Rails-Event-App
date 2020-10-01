class Event < ApplicationRecord
    has_many :rsvsps 
    has_many :users, through: :rsvsps
    belongs_to :producer
    belongs_to :location
end
