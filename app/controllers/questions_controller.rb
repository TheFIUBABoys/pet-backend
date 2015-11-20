class QuestionsController < ApplicationController

  before_action :set_pet, only: [:index, :create, :show, :answer, :report, :block, :unblock]
  before_action :set_pet_question, only: [:show, :answer, :report, :block, :unblock]

  def index
    @pet_questions = @pet.questions.not_blocked.order(created_at: :desc)
  end

  def show
  end

  def create
    @pet_question = @pet.questions.create(body: question_params[:body], user: current_user)

    respond_to do |format|
      format.html { redirect_to @pet, notice: I18n.t("pets.edit.question_created") }
      format.json { render :show }
    end
  end

  def answer
    PetQuestionAnswer.create(pet_question: @pet_question, body: answer_params[:body])

    respond_to do |format|
      format.html { redirect_to @pet, notice: I18n.t("pets.edit.answer_created") }
      format.json { render :show }
    end
  end

  def report
    @pet_question.report!

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pet_questions.reported") }
      format.json { head :no_content }
    end
  end

  def block
    @pet_question.block!

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pet_questions.blocked") }
      format.json { head :no_content }
    end
  end

  def unblock
    @pet_question.unblock!

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: I18n.t("pet_questions.unblocked") }
      format.json { head :no_content }
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def set_pet_question
    @pet_question = @pet.questions.find(params[:id] || params[:question_id])
  end

  def question_params
    params.require(:pet_question).permit(:body)
  end

  def answer_params
    params.require(:pet_question_answer).permit(:body)
  end

end
