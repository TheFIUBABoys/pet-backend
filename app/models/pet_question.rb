class PetQuestion < ActiveRecord::Base
  belongs_to :pet
  belongs_to :user

  validates_presence_of :body
end
