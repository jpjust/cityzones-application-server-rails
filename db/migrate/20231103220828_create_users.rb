class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.boolean :admin, :null => false, :default => false
        t.string :email, :null => false
        t.string :password_digest, :null => false
        t.string :name, :null => false
        t.string :company

        t.timestamps
      end

      add_index :users, :email, :unique => true
    end
  end
end
