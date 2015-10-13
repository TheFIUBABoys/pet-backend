class AdoptionRequestsController < ApplicationController

  before_action :set_pet, only: [:index, :create]

  def index
    @adoption_requests = @pet.adoption_requests
  end

  def create
    @adoption_request = @pet.adoption_requests.first_or_create(user: current_user)
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

end
