class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy, :report, :block, :unblock, :block_owner, :unblock_owner]

  # GET /pets
  # GET /pets.json
  def index
    pets = pets_from_query

    respond_to do |format|
      format.html do
        @pets = pets.paginate(page: params[:page], per_page: 10)
      end
      format.json do
        @pets = pets
      end
    end
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
    @pet_image = @pet.images.new
  end

  # POST /pets
  # POST /pets.json
  def create
    pet_response = pet_create_service.call(pet_params)
    lost_pet_match_service.call(pet_response)

    @pet = pet_response

    respond_to do |format|
      if pet_response.success?
        format.html { redirect_to pet_response, notice: I18n.t("pets.show.created") }
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
        format.html { redirect_to @pet, notice: I18n.t("pets.show.updated") }
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
      format.html { redirect_to pets_url, notice: I18n.t("pets.index.destroyed") }
      format.json { head :no_content }
    end
  end

  def reported
    pets = pets_from_query(Pet.reported, true)

    @pets = pets.paginate(page: params[:page], per_page: 10)
  end

  def reported_users
    users = User.where(reported: true)

    order_by = user_search_params.delete(:order_by) || "id"

    users = users.where(user_search_params)
    users = users.order(order_by => :asc)

    @users = users.paginate(page: params[:page], per_page: 10)
  end

  def reported_questions
    questions = PetQuestion.reported

    @questions = questions.paginate(page: params[:page], per_page: 10)
  end

  # POST /pets/1/report.json
  def report
    @pet.report!
    @pet.user.report!
    head :no_content
  end

  # POST /pets/1/block.json
  def block
    @pet.block!

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pets.blocked") }
      format.json { head :no_content }
    end
  end

  # POST /pets/1/block.json
  def unblock
    @pet.unblock!

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pets.unblocked") }
      format.json { head :no_content }
    end
  end

  # POST /pets/1/block_owner.json
  def block_owner
    @pet.user.block!

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pets.blocked_user") }
      format.json { head :no_content }
    end
  end

  # POST /pets/1/block_owner.json
  def unblock_owner
    @pet.user.unblock!

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pets.unblocked_user") }
      format.json { head :no_content }
    end
  end

  # POST /pets/block_owner_publications.json
  def block_owner_publications
    User.find(params[:id]).pets.each { |pet| pet.block! }

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pets.blocked_user_publications") }
      format.json { head :no_content }
    end
  end

  # POST /pets/unblock_owner_publications.json
  def unblock_owner_publications
    User.find(params[:id]).pets.each { |pet| pet.unblock! }

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pets.unblocked_user_publications") }
      format.json { head :no_content }
    end
  end

  def top
    @pets = Pet.where(:published => true).order(created_at: :desc).limit(5)

    render :index
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pet
    @pet = Pet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pet_params
    params.require(:pet).
      permit(:type, :name, :description, :gender, :colors, :needs_transit_home, :published, :vaccinated, :location,
             :metadata, :age, :children_friendly, :pet_friendly, :publication_type, videos: [])
  end

  def pet_search_params
    params.
      permit(:type, :name, :description, :gender, :colors, :needs_transit_home, :vaccinated, :published, :user_id,
             :metadata, :location, :age, :limit, :children_friendly, :pet_friendly, :with_adoption_requests,
             :adopted, :adopted_by_me, :requested_by_me, :publication_type, :order_by).
      reject { |_, v| v.blank? }
  end

  def pet_create_service
    @pet_create_service ||= PetCreateService.new(current_user)
  end

  def lost_pet_match_service
    @lost_pet_match_service ||= LostPetMatchService.new
  end

  def pets_from_query(base_pets = nil, override_published = false)
    params = pet_search_params
    limit  = params.delete(:limit)

    color_query    = params.delete(:colors)
    metadata_query = params.delete(:metadata)
    location_query = params.delete(:location)
    adopted        = params.delete(:adopted)
    adopted_by_me  = params.delete(:adopted_by_me)
    requested_by_me  = params.delete(:requested_by_me)
    published  = params.delete(:published)
    order_by  = params.delete(:order_by)

    with_adoption_requests = params.delete(:with_adoption_requests)

    pets = base_pets || Pet
    pets = pets.where(params)
    pets = pets.with_metadata(metadata_query) if metadata_query.present?
    pets = pets.with_colors(color_query) if color_query.present?
    pets = pets.near_location(location_query, params.fetch(:location_range, 5000)) if location_query.present?

    # May return unpublished pets.
    pets = pets.includes(:adoption_requests).where(adoption_requests: { approved: [true, false] }) if with_adoption_requests.present?
    pets = pets.includes(:adoption_requests).where(adoption_requests: { approved: true }) if adopted.present?
    pets = pets.includes(:adoption_requests).where(adoption_requests: { approved: true, user_id: current_user.id }) if adopted_by_me.present?
    pets = pets.includes(:adoption_requests).where(adoption_requests: { user_id: current_user.id }).where(['pets.user_id <> ?', current_user.id]) if requested_by_me.present?

    # Published pets by default.
    unless override_published
      pets = pets.published unless adopted.present? || adopted_by_me.present? || requested_by_me.present? ||
        (published.present? && published == 'false')
    end

    if order_by.present?
      pets = pets.order(order_by => :asc)
    else
      pets = pets.order(created_at: :desc)
    end

    pets = pets.limit(limit) if limit

    pets
  end

  def user_search_params
    params.permit(:order_by, :first_name, :last_name).reject { |_, v| v.blank? }
  end

end
