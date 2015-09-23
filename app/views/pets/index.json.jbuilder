json.array!(@pets) do |pet|
  json.extract! pet, :id, :type, :name, :description, :published, :vaccinated, :needs_transit_home, :created_at, :updated_at, :user_id, :location, :metadata, :colors, :gender
  json.url pet_url(pet, format: :json)
  json.images do
    json.array! pet.images do |image|
      json.id image.id
      json.original_url "#{request.protocol}#{request.host}:#{request.port}#{image.image.url}"
      json.medium_url "#{request.protocol}#{request.host}:#{request.port}#{image.image.url(:medium)}"
      json.thumb_url "#{request.protocol}#{request.host}:#{request.port}#{image.image.url(:thumb)}"
    end
  end
end
