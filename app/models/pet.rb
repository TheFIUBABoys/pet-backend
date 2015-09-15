class Pet < ActiveRecord::Base

  belongs_to :user
  validates :user, presence: true

  validates_format_of :location, with: /[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)/

  def publish
    self.published = true
  end

  def unpublish
    self.published = false
  end

  def publish!
    self.update_attributes(published: true)
  end

  def unpublish!
    self.update_attributes(published: false)
  end

end
