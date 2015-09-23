json.array!(@pets) do |pet|
  json.extract! pet, :id, :type, :name, :description, :published, :vaccinated, :needs_transit_home, :created_at, :updated_at, :user_id, :location, :metadata, :colors, :gender
  json.url pet_url(pet, format: :json)
end
