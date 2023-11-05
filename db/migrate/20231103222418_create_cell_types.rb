class CreateCellTypes < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:cell_types)
      create_table :cell_types do |t|
        t.string :name, :null => false
        t.timestamps
      end
    end
  end
end
