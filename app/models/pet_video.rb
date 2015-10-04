class PetVideo < ActiveRecord::Base
  belongs_to :pet

  validates_presence_of :url
end
