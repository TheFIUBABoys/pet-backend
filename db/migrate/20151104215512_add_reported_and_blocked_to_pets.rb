class AddReportedAndBlockedToPets < ActiveRecord::Migration
  def change
    add_column :pets, :reported, :boolean, default: false
    add_column :pets, :blocked, :boolean, default: false
  end
end
