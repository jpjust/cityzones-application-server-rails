class CreateResults < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:results)
      create_table :results do |t|
        t.references :task, :foreign_key => true, :null => false
        t.json :res_data
        
        t.timestamps
      end
    end
  end
end
