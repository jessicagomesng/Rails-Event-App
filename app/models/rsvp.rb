class Rsvp < ApplicationRecord
    belongs_to :user
    belongs_to :event

    validates_uniqueness_of :user_id, :scope => :event_id, :message => "has already signed up to this event/waiting list."

    scope :attending, -> { where(:status => "attending") }
    scope :waiting, -> { where(:status => "waiting") }
end

