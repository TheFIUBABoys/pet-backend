class AddColorsMetadataGenderToPets < ActiveRecord::Migration
  def up
    add_column :pets, :colors, :string
    add_column :pets, :gender, :string
    add_column :pets, :metadata, :text, default: ""

    Pet.update_all(gender: Pet::GENDER_MALE)
  end

  def down
    remove_column :pets, :colors
    remove_column :pets, :gender
    remove_column :pets, :metadata
  end
end
