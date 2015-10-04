class SetChildrenFriendlyDefault < ActiveRecord::Migration
  def change
    change_column_null :pets, :children_friendly, true
    change_column_default :pets, :children_friendly, false
  end
end
