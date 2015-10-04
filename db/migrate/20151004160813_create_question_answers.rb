class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :pet_question_answers do |t|
      t.references :pet_question, index: true
      t.text :body, default: "", null: false

      t.timestamps
    end
  end
end
