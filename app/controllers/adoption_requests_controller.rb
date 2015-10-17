class AdoptionRequestsController < ApplicationController

  before_action :set_pet, only: [:index, :create]

  def index
    @adoption_requests = @pet.adoption_requests
  end

  def create
    @adoption_request = @pet.adoption_requests.find_or_initialize_by(user: current_user)

    unless @adoption_request.persisted?
      @adoption_request.save!
      notification_service.call(@pet.user, notification_options)
    end

    head :created
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def notification_options
    { data: { pet_id: @pet.id, user_id: current_user.id }, collapse_key: 'adoption_requested' }
  end

  def notification_service
    @notification_service ||= SendPushNotificationService.new
  end

end
