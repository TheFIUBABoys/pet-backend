class PetImage < ActiveRecord::Base
  belongs_to :pet
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image

  before_post_process on: :create do
    if image_content_type == 'application/octet-stream'
      mime_type = MIME::Types.type_for(image_file_name)
      self.image_content_type = mime_type.first.to_s if mime_type.first
    end
  end
end
