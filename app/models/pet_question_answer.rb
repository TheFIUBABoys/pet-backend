class PetQuestionAnswer < ActiveRecord::Base
  belongs_to :pet_question

  validates_presence_of :body
end
