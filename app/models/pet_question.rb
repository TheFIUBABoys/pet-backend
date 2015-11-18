class PetQuestion < ActiveRecord::Base
  belongs_to :pet
  belongs_to :user
  has_one :answer, class_name: PetQuestionAnswer

  scope :reported, ->    { where(reported: true) }
  scope :blocked, ->     { where(blocked: true) }
  scope :not_blocked, -> { where(blocked: false) }

  validates_presence_of :body

  def report
    self.reported = true
  end

  def report!
    self.report
    self.save!
  end

  def block
    self.blocked = true
  end

  def block!
    self.block
    self.save!
  end

  def unblock
    self.blocked = false
  end

  def unblock!
    self.unblock
    self.save!
  end
end
