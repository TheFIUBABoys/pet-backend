class Pet < ActiveRecord::Base

  belongs_to :user
  validates :user, presence: true

  has_many :images, class_name: PetImage

  validates_format_of :location, with: /[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)/, if: :location?

  %w[male female].each do |gender|
    const_set "gender_#{gender}".upcase, gender
  end

  GENDERS = [GENDER_MALE, GENDER_FEMALE]
  validates_inclusion_of :gender, in: GENDERS, allow_blank: false

  TYPES = [Cat.name, Dog.name]
  validates_inclusion_of :type, in: TYPES, allow_blank: false

  before_save :update_metadata

  scope :published, -> { where(published: true) }
  scope :males,   -> { where(gender: GENDER_MALE) }
  scope :females, -> { where(gender: GENDER_FEMALE) }
  scope :with_colors, ->(colors) {
    full_query = nil

    to_queries(colors).each do |query|
      color_match = arel_table[:colors].matches(query)
      full_query = full_query ? full_query.and(color_match) : color_match
    end

    where(full_query)
  }
  scope :with_metadata, ->(tags) {
    full_query = nil

    to_queries(tags).each do |query|
      meta_match = arel_table[:metadata].matches(query)
      full_query = full_query ? full_query.or(meta_match) : meta_match
    end

    where(full_query)
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

  def self.to_queries(query)
    query.to_s.strip.split.map { |w| "%#{w.downcase}%" }
  end

  def update_metadata
    tags = []

    # Tag pet based on type, gender and colors.
    %w[type gender].each do |attribute|
      attribute = attribute.to_sym
      tags << I18n.t("pets.#{self.send(attribute).downcase}").downcase if self.send(attribute)
    end
    tags << self.colors

    # Merge with existing tags.
    new_meta = tags.compact
    existing_meta = self.metadata.split(" ")

    self.metadata = new_meta.concat(existing_meta).uniq.join(" ")
  end

end
