class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy]

  # GET /pets
  # GET /pets.json
  def index
    if pet_search_params.any?
      @pets = Pet.where(pet_search_params).order(created_at: :desc)
    else
      @pets = Pet.all.order(created_at: :desc)
    end

    @pets = @pets.limit(params[:limit]) if params[:limit]
  end

  # GET /pets/1
  # GET /pets/1.json
  def show
  end

  # GET /pets/new
  def new
    @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets
  # POST /pets.json
  def create
    pet_response = pet_create_service.call(pet_params)

    @pet = pet_response

    respond_to do |format|
      if pet_response.success?
        format.html { redirect_to pet_response, notice: 'Pet was successfully created.' }
        format.json { render :show, status: :created, location: pet_response }
      else
        format.html { render :new }
        format.json { render json: pet_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1
  # PATCH/PUT /pets/1.json
  def update
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @pet, notice: 'Pet was successfully updated.' }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1
  # DELETE /pets/1.json
  def destroy
    @pet.destroy
    respond_to do |format|
      format.html { redirect_to pets_url, notice: 'Pet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def top
    @pets = Pet.all.order(created_at: :desc).limit(5)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pet
    @pet = Pet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pet_params
    params.require(:pet).
      permit(:type, :name, :description, :gender, :colors, :needs_transit_home, :published, :location, :metadata)
  end

  def pet_search_params
    params.permit(:type, :name, :description, :gender, :colors, :needs_transit_home, :published, :user_id, :metadata)
  end

  def pet_create_service
    @pet_create_service ||= PetCreateService.new(current_user)
  end
end
