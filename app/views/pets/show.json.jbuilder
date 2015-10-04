json.extract! @pet, :id, :type, :name, :age, :description, :published, :vaccinated, :needs_transit_home, :created_at, :updated_at, :user_id, :location, :metadata, :colors, :gender

json.images do
  json.array! @pet.images do |image|
    json.id image.id
    json.original_url asset_url(image.image.url)
    json.medium_url asset_url(image.image.url(:medium))
    json.thumb_url asset_url(image.image.url(:thumb))
  end
end

json.videos do
  json.array! @pet.videos do |video|
    json.id video.id
    json.url video.url
  end
end
