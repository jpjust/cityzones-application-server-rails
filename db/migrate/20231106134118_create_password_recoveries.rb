class CreatePasswordRecoveries < ActiveRecord::Migration[7.0]
  def change
    create_table :password_recoveries do |t|
      t.integer :user_id, :null => false
      t.string :token, :null => false
      t.datetime :expires_at, :null => false

      t.timestamps
    end

    add_foreign_key(:password_recoveries, :users)
  end
end
