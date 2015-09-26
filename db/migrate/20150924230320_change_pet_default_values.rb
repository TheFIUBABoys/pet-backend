class ChangePetDefaultValues < ActiveRecord::Migration
  def up
    change_column_default :pets, :colors, ""
    change_column_default :pets, :location, ""
  end
end
