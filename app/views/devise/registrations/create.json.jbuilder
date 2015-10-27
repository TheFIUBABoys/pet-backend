json.extract! current_user, :id, :created_at, :email, :facebook_id, :authentication_token, :full_name, :first_name, :last_name, :location, :phone, :reported, :blocked
json.profile_complete current_user.profile_complete?
