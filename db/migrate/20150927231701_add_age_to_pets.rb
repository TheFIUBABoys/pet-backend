class AddAgeToPets < ActiveRecord::Migration
  def up
    add_column :pets, :age, :integer

    Pet.update_all(age: 2)
  end

  def down
    remove_column :pets, :age
  end
end
