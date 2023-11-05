class AddLastAccessToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_access_at, :datetime
  end
end
