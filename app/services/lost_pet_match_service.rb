class LostPetMatchService < BaseService

  def call(pet)
    return unless Pet::LOST_AND_FOUND.include?(pet.publication_type)
    publication_type = Pet::LOST_AND_FOUND - [pet.publication_type]

    matches = Pet.where.not(user_id: pet.user.id).
      where(publication_type: publication_type).
      where(pet.attributes.slice(*match_params)).
      near_location(pet.location, 5000)

    notify_pet_matches(pet, matches) if matches.any?

    ModelResponse.new(matches)
  end

  private

  def match_params
    %w[type colors gender]
  end

  def notification_options(pet)
    notification_type = "lost_pet_match"

    { data: { pet_id: pet.id, user_id: pet.user.id, type: notification_type }, collapse_key: notification_type }
  end

  def notification_service
    @notification_service ||= SendPushNotificationService.new
  end

  def notify_pet_matches(pet, pet_matches)
    pet_matches.each { |matched_pet| notification_service.call(pet.user, notification_options(matched_pet)) }
  end

end
