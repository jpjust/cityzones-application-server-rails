class CreateCells < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:cells)
      create_table :cells do |t|
        t.references :cell_type, :foreign_key => true
        t.point :coord, :null => false
        t.integer :radius, :null => false
        t.timestamps
      end

      add_index :cells, :coord
    end
  end
end
