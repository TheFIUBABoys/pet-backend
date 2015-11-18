class AddReportedAndBlockedToQuestions < ActiveRecord::Migration
  def change
    add_column :pet_questions, :reported, :boolean, default: false
    add_column :pet_questions, :blocked,  :boolean, default: false
  end
end
