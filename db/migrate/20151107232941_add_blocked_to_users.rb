class AddBlockedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blocked_until, :datetime, default: nil
  end
end
