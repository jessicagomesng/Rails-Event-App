class Event < ApplicationRecord
    has_many :rsvsps 
    has_many :users, through: :rsvsps
    belongs_to :producer
    belongs_to :location

    validates :producer_id, :location_id, :name, :price, :maximum_capacity, presence: true
    validates :start_date, :end_date, presence: { message: "and/or time cannot be left blank." }

    includes ActiveModel::Validations
    validates_with EndDateValidator
    validates_with MaximumCapacityValidator
    validates_with LocationIdValidator


    scope :upcoming, -> { where("start_date > ?", DateTime.now) } 
    scope :past, -> { where("end_date < ?", DateTime.now) }
end
