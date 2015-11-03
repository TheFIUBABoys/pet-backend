class Pet < ActiveRecord::Base

  belongs_to :user
  validates :user, presence: true

  has_many :images, class_name: PetImage
  has_many :videos, class_name: PetVideo
  has_many :questions, class_name: PetQuestion
  has_many :adoption_requests

  # validates_format_of :location, with: /[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)/, if: :location?

  %w[male female].each do |gender|
    const_set "gender_#{gender}".upcase, gender
  end

  GENDERS = [GENDER_MALE, GENDER_FEMALE]
  validates_inclusion_of :gender, in: GENDERS, allow_blank: false

  %w[adoption lost found].each do |publication_type|
    const_set "PUBLICATION_TYPE_#{publication_type}".upcase, publication_type
  end

  LOST_AND_FOUND    = [PUBLICATION_TYPE_LOST, PUBLICATION_TYPE_FOUND]
  PUBLICATION_TYPES = [PUBLICATION_TYPE_ADOPTION] + LOST_AND_FOUND
  validates_inclusion_of :publication_type, in: PUBLICATION_TYPES, allow_blank: true

  TYPES = ["Dog", "Cat"]
  validates_inclusion_of :type, in: TYPES, allow_blank: false

  before_save :update_metadata

  scope :published, -> { where(published: true) }
  scope :males, ->     { where(gender: GENDER_MALE) }
  scope :females, ->   { where(gender: GENDER_FEMALE) }

  scope :near_location, ->(location, max_meters) {
    location_ary = location.split(",").map(&:to_f)

    ids = where.not(location: [nil, ""]).select { |pet| pet.distance_to(location_ary) <= max_meters }.map(&:id)
    where(id: ids)
  }

  scope :with_colors, ->(colors) { field_matches_any(:colors, colors) }
  scope :with_metadata, ->(tags) { field_matches_any(:metadata, tags) }

  scope :approved, -> { includes(:adoption_requests).where(adoption_requests: { approved: true }) }
  scope :lost, -> { where(publication_type: PUBLICATION_TYPE_LOST) }
  scope :found, -> { where(publication_type: PUBLICATION_TYPE_FOUND) }
  scope :for_adoption, -> { where(publication_type: PUBLICATION_TYPE_ADOPTION) }

  def publish
    self.published = true
  end

  def unpublish
    self.published = false
  end

  def publish!
    self.publish
    self.save!
  end

  def unpublish!
    self.unpublish
    self.save!
  end

  def metadata_matches(values)
    values.split.count { |tag| self.metadata.include?(tag) }
  end

  def distance_to(other_location)
    loc1 = self.location.split(",").map(&:to_f)
    loc2 = other_location

    rad_per_deg = Math::PI/180 # PI / 180
    rkm = 6371 # Earth radius in kilometers
    rm = rkm * 1000 # Radius in meters

    dlat_rad = (loc2[0] - loc1[0]) * rad_per_deg # Delta, converted to rad
    dlon_rad = (loc2[1] - loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map { |i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map { |i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end

  private

  def self.to_queries(query)
    query.to_s.strip.split.map { |w| "%#{w.downcase}%" }
  end

  def self.field_matches_any(field, values)
    full_query = nil

    to_queries(values).each do |query|
      field_match = arel_table[field].matches(query)
      full_query  = full_query ? full_query.or(field_match) : field_match
    end

    where(full_query)
  end

  def update_metadata
    tags = []

    # Tag pet based on type, gender and colors.
    %w[type gender].each do |attribute|
      attribute = attribute.to_sym
      tags << I18n.t("pets.#{self.send(attribute).downcase}") if self.send(attribute)
    end
    tags = tags.concat self.colors.split unless self.colors.blank?
    tags = tags.concat self.description.split unless self.description.blank?

    # Merge with existing tags.
    new_meta = tags.compact.map(&:downcase)
    existing_meta = self.metadata.split(" ")

    self.metadata = new_meta.concat(existing_meta).uniq.join(" ")
  end

end
