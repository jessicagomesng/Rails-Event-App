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

    includes ActiveModel::Validations 
    validates_with EmailValidator, :on => :create

    def age 
        now = Time.now.utc.to_date 
        dob = self.birthday

        now.year - dob.year - (((now.month - dob.month) > 0 || (now.month >= dob.month && now.day >= dob.day)) ? 0 : 1)
    end 

    def events_attending
        self.rsvps.attending.collect { |rsvp| Event.find_by_id(rsvp.event_id) }
    end

    def events_waiting_for
        self.rsvps.waiting.collect { |rsvp| Event.find_by_id(rsvp.event_id) }
    end 

    def place_in_line(event)
        event.waiting_users.index { |waiting_user| waiting_user == self } + 1
    end 

    def self.from_omniauth(auth)
        where(email: auth["info"]["email"]).first_or_create do |user|
            user.id = auth["uid"]
            user.first_name = auth["info"]["first_name"]
            user.last_name = auth["info"]["last_name"]
            user.email = auth["info"]["email"]
            bday_hash = auth["extra"]["raw_info"]["birthday"].split("/").collect { |n| n.to_i }
            user.birthday = Date.new(bday_hash[2], bday_hash[0], bday_hash[1])
            user.password = user.password_confirmation = SecureRandom.urlsafe_base64(n=6)
        end
    end 
end
