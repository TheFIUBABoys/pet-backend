class AddBooleansToPets < ActiveRecord::Migration
  def up
    add_column :pets, :pet_friendly, :boolean, default: nil
    add_column :pets, :children_friendly, :boolean, default: nil

    change_column_default :pets, :vaccinated, nil
  end

  def down
    remove_column :pets, :pet_friendly
    remove_column :pets, :children_friendly
  end
end
