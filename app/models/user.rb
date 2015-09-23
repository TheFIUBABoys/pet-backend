class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :lockable

  before_save :ensure_authentication_token

  validates :email, uniqueness: true, allow_nil: true, allow_blank: true
  validates :facebook_id, uniqueness: true, allow_nil: true, allow_blank: true

  validates_presence_of :facebook_id, unless: :email?
  validates_presence_of :facebook_token, unless: :email?

  has_many :pets

  def email_required?
    facebook_token.blank?
  end

  def password_required?
    facebook_token.blank?
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
