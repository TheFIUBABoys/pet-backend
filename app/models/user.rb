class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :lockable

  before_save :ensure_authentication_token

  validates :email, uniqueness: true, allow_nil: true, allow_blank: true
  validates :facebook_id, uniqueness: true, allow_nil: true, allow_blank: true

  validates_presence_of :facebook_id, unless: :email?
  validates_presence_of :facebook_token, unless: :email?

  has_many :pets
  has_many :adoption_requests

  def email_required?
    email_and_password_required?
  end

  def password_required?
    email_and_password_required?
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def full_name
    return "" if self.first_name.blank? && self.last_name.blank?

    [self.first_name, self.last_name].reject(&:blank?).join(" ")
  end

  def profile_complete?
    %w[phone first_name last_name location email].all? { |attribute| self.send(attribute).present? }
  end

  def blocked?
    self.blocked_until.present? && self.blocked_until > Time.now
  end

  def block
    self.blocked_until = 1.week.from_now
  end

  def block!
    self.block
    self.save!
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def email_and_password_required?
    self.facebook_token.blank? && !self.persisted?
  end

end
