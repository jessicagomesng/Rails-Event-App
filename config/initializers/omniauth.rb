Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
      scope: 'public_profile,user_birthday,email', info_fields: 'id,email,link,birthday,first_name,last_name'
end