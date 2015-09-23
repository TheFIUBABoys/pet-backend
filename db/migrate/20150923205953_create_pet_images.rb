class CreatePetImages < ActiveRecord::Migration
  def up
    create_table :pet_images do |t|
      t.references :pet, index: true
    end

    add_attachment :pet_images, :image
  end

  def down
    drop_table :pet_images

    remove_attachment :pet_images, :image
  end
end
