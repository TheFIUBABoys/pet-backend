class AddLocationToPets < ActiveRecord::Migration
  def change
    add_column :pets, :location, :string, default: nil
  end
end
