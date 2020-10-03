class Event < ApplicationRecord
    has_many :rsvps 
    has_many :users, through: :rsvps
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

    def attending_users 
        self.rsvps.attending.collect { |rsvp| User.find_by_id(rsvp.user_id) }
    end 

    def waiting_users 
        self.rsvps.waiting.collect { |rsvp| User.find_by_id(rsvp.user_id) }
    end 

    def attendance_count
        self.attending_users.count 
    end 

    def waiting_count 
        self.waiting_users.count 
    end 

    def full?
        self.attendance_count >= self.maximum_capacity 
    end 
end
