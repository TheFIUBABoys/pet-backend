class PetImage < ActiveRecord::Base
  belongs_to :pet
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  before_validation(on: :create) do |file|
    if file.image_content_type == "application/octet-stream"
      mime_type = MIME::Types.type_for(file.image_file_name)
      file.image_content_type = mime_type.first.content_type if mime_type.first
    end
  end
end
