class ImagesController < ApplicationController

  before_action :set_pet, only: [:create, :show, :destroy]
  before_action :set_pet_image, only: [:show, :destroy]

  def show
  end

  def create
    @pet_image = @pet.images.create(image: image_params[:image])

    respond_to do |format|
      format.html { redirect_to @pet, notice: I18n.t("pets.edit.image_created") }
      format.json { render :show }
    end
  end

  def destroy
    @pet_image.destroy
    respond_to do |format|
      format.html { redirect_to pets_url, notice: I18n.t("pets.edit.image_destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def set_pet_image
    @pet_image = @pet.images.find(params[:id])
  end

  def image_params
    params.require(:pet_image).permit(:image)
  end

end
