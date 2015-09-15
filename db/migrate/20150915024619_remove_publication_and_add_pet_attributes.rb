class RemovePublicationAndAddPetAttributes < ActiveRecord::Migration
  def change
    drop_table :publications

    add_column :pets, :needs_transit_home, :boolean, null: false, default: false
    add_column :pets, :published, :boolean, null: false, default: false
    add_reference :pets, :user, index: true
  end
end
