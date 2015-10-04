class SetPetFriendlyDefault < ActiveRecord::Migration
  def change
    change_column_null :pets, :pet_friendly, true
    change_column_default :pets, :pet_friendly, false
  end
end
