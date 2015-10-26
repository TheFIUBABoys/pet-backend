class AdoptionRequestsController < ApplicationController

  before_action :set_pet, only: [:index, :create, :accept]
  before_action :set_adoption_request, only: [:accept]

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

  def accept
    @adoption_request.update_attributes(approved: true)
    @pet.unpublish!

    notification_service.call(@adoption_request.user, notification_options)

    head :created
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def set_adoption_request
    @adoption_request = @pet.adoption_requests.find(params[:id])
  end

  def notification_options
    notification_type = "#{action_name}_adoption_request"

    { data: { pet_id: @pet.id, user_id: current_user.id, type: notification_type }, collapse_key: notification_type }
  end

  def notification_service
    @notification_service ||= SendPushNotificationService.new
  end

end
