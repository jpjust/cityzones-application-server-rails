class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:tasks)
      create_table :tasks do |t|
        t.references :user, :foreign_key => true, :null => false
        t.string :bane_filename, :null => false
        t.json :config, :null => false
        t.json :geojson, :null => false
        t.float :lat, :null => false
        t.float :lon, :null => false
        t.datetime :requested_at
        t.string :description
        t.integer :requests, :null => false, :default => 0

        t.timestamps
      end

      add_index :tasks, :base_filename, :unique => true
    end
  end
end
