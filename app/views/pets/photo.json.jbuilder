json.id @pet_photo.id
json.original_url "#{request.protocol}#{request.host}:#{request.port}#{@pet_photo.image.url}"
json.medium_url "#{request.protocol}#{request.host}:#{request.port}#{@pet_photo.image.url(:medium)}"
json.thumb_url "#{request.protocol}#{request.host}:#{request.port}#{@pet_photo.image.url(:thumb)}"
