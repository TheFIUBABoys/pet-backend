json.array!(@adoption_requests) do |adoption_request|
  json.extract! adoption_request, :approved
  json.user do
    json.extract! adoption_request.user, :id, :created_at, :email, :facebook_id, :authentication_token, :full_name, :first_name, :last_name, :location, :phone
  end
end
