class ImagesController < ApplicationController

  before_action :set_pet, only: [:create]

  def create
    pet_photo = @pet.images.create(image: params[:pet_image][:image])

    respond_to do |format|
      format.html { redirect_to @pet, notice: 'Image uploaded successfully.' }
      format.json { @pet_photo = pet_photo }
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

end
