class CreatePetVideos < ActiveRecord::Migration
  def change
    create_table :pet_videos do |t|
      t.references :pet, index: true
      t.string :url, null: false, default: ""

      t.timestamps
    end
  end
end
