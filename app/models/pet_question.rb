class PetQuestion < ActiveRecord::Base
  belongs_to :pet
  belongs_to :user
  has_one :answer, class_name: PetQuestionAnswer

  validates_presence_of :body
end
