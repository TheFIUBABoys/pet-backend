class Pet < ActiveRecord::Base

  belongs_to :user
  validates :user, presence: true

  validates_format_of :location, with: /[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)/

  %w[male female].each do |gender|
    const_set "gender_#{gender}".upcase, gender
  end

  GENDERS = [GENDER_MALE, GENDER_FEMALE]

  validates_inclusion_of :gender, in: GENDERS, allow_blank: false

  before_save :update_metadata

  scope :males,   -> { where(gender: GENDER_MALE) }
  scope :females, -> { where(gender: GENDER_FEMALE) }
  scope :with_colors, ->(colors) {
    full_query = nil

    colors.split.each do |color|
      query = "%#{color}%"
      color_match = arel_table[:colors].matches(query)
      full_query = full_query ? full_query.and(color_match) : color_match
    end

    where(full_query)
  }
  scope :with_metadata, ->(query) {
    words = query.to_s.strip.split
    words.map! { |word| "metadata LIKE '%#{word}%'" }
    where(words.join(" OR "))
  }

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

  private

  def update_metadata
    tags = []

    # Tag pet based on type, gender and colors.
    %i[type gender].each do |attribute|
      tags << I18n.t("pets.#{self.send(attribute).downcase}")
    end
    tags << self.colors

    # Merge with existing tags.
    new_meta = tags.compact
    existing_meta = self.metadata.split(" ")

    self.metadata = new_meta.concat(existing_meta).uniq.join(" ")
  end

end
