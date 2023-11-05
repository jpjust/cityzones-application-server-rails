class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:workers)
      create_table :workers do |t|
        t.string :token, :null => false
        t.string :name, :null => false
        t.string :description
        t.integer :tasks, :null => false, :default => 0
        t.datetime :last_task_at
        t.float :total_time, :null => false, :default => 0

        t.timestamps
      end

      add_index :workers, :token, :unique => true
    end
  end
end
