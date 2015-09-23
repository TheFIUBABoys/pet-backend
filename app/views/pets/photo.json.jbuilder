json.id @pet_photo.id
json.original_url asset_url(@pet_photo.image.url)
json.medium_url asset_url(@pet_photo.image.url(:medium))
json.thumb_url asset_url(@pet_photo.image.url(:thumb))
