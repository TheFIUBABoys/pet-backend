class AdoptionRequest < ActiveRecord::Base

  belongs_to :user
  validates :user, presence: true

  belongs_to :pet
  validates :pet, presence: true

end
