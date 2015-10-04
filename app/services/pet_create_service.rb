class PetCreateService < BaseService

  def initialize(user)
    @user = user
  end

  def call(pet_attributes, publish: false)
    pet_videos = pet_attributes.delete(:videos)

    pet = @user.pets.create(pet_attributes)
    pet = create_videos(pet, pet_videos)

    pet.publish! if publish

    ModelResponse.new(pet)
  end

  private

  def create_videos(pet, pet_videos)
    pet_videos.reject(&:blank?).each do |url|
      pet.videos.create(url: url)
    end

    pet
  end

end
