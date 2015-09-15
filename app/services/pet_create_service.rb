class PetCreateService < BaseService

  def initialize(user)
    @user = user
  end

  def call(pet_attributes, publish: false)
    pet = @user.pets.create(pet_attributes)

    pet.publish! if publish

    ModelResponse.new(pet)
  end

end
