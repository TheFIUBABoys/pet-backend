class QuestionsController < ApplicationController

  before_action :set_pet, only: [:create, :show, :answer]
  before_action :set_pet_question, only: [:show, :answer]

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
