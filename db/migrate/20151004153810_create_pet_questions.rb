class CreatePetQuestions < ActiveRecord::Migration
  def change
    create_table :pet_questions do |t|
      t.references :pet, index: true
      t.references :user, index: true
      t.text :body, null: false, default: ""

      t.timestamps
    end
  end
end
