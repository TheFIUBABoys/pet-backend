json.id @pet_image.id
json.original_url asset_url(@pet_image.image.url)
json.medium_url asset_url(@pet_image.image.url(:medium))
json.thumb_url asset_url(@pet_image.image.url(:thumb))
