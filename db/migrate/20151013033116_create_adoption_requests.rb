class CreateAdoptionRequests < ActiveRecord::Migration
  def change
    create_table :adoption_requests do |t|
      t.references :pet, index: true
      t.references :user, index: true
      t.boolean :approved, default: false, null: false

      t.timestamps null: false
    end
  end
end
