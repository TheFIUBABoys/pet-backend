class AddPublicationTypeToPets < ActiveRecord::Migration
  def change
    add_column :pets, :publication_type, :string, default: "adoption"
  end
end
