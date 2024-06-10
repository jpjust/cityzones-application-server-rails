class SwitchFromJsonToFields < ActiveRecord::Migration[7.0]
  def up
    create_table :pois do |t|
      t.string :category, :null => false
      t.string :poi_type, :null => false
    
      t.timestamps
    end

    create_table :tasks_pois do |t|
      t.references :task, :foreign_key => :true, :type => :integer
      t.references :poi, :foreign_key => true
      t.integer :w, :null => false
    
      t.timestamps
    end
    
    add_column :tasks, :left,         :float,   :null => false
    add_column :tasks, :right,        :float,   :null => false
    add_column :tasks, :bottom,       :float,   :null => false
    add_column :tasks, :top,          :float,   :null => false
    add_column :tasks, :polygon,      :text,    :null => false
    add_column :tasks, :zone_size,    :integer, :null => false
    add_column :tasks, :classes,      :integer, :null => false
    add_column :tasks, :edus_loose,   :integer, :null => false
    add_column :tasks, :edus_tight,   :integer, :null => false
    add_column :tasks, :edu_alg,      :string,  :null => false
    add_column :tasks, :pois_use_all, :boolean, :null => false
    
    add_column :results, :n_zones,             :integer, :null => false
    add_column :results, :n_zones_by_rl,       :string,  :null => true
    add_column :results, :n_pois,              :integer, :null => false
    add_column :results, :n_edus_tight,        :integer, :null => false
    add_column :results, :n_edus_loose,        :integer, :null => false
    add_column :results, :time_classification, :float,   :null => false
    add_column :results, :time_positioning,    :float,   :null => false

    # Create PoIs
    Poi.reset_column_information
    Poi.create!([
      { category: 'amenity', poi_type: 'hospital '},
      { category: 'amenity', poi_type: 'fire_station '},
      { category: 'amenity', poi_type: 'police '},
      { category: 'railway', poi_type: 'station '}
    ])

    # Convert tasks and results
    Task.reset_column_information
    Result.reset_column_information

    Task.all.each do |task|
      puts("task #{task.id}")
      task_config = task.config.is_a?(Hash) ? task.config : JSON.parse(task.config)
      task_geojson = task.geojson.is_a?(Hash) ? task.geojson : JSON.parse(task.geojson)

      task.left = task_config['left']
      task.right = task_config['right']
      task.bottom = task_config['bottom']
      task.top = task_config['top']
      task.polygon = task_geojson['features'][0]['geometry']['coordinates'][0].to_s
      task.zone_size = task_config['zone_size']
      task.classes = task_config['M']
      task.edus_loose = task_config['edus'].is_a?(Hash) ? task_config['edus']['loose'] : task_config['edus']
      task.edus_tight = task_config['edus'].is_a?(Hash) ? task_config['edus']['tight'] : 0
      task.edu_alg = task_config['edu_alg']
      task.pois_use_all = task_config['pois_use_all'].present? ? task_config['pois_use_all'] : false

      task_config['pois_types'].each do |category, types|
        types.each do |type, value|
          poi = Poi.where(category: category, poi_type: type).first
          next unless poi.present?

          TaskPoi.create!({
            task: task,
            poi: poi,
            w: value['w']
          })
        end
      end

      if task.result.present?
        res_data = task.result.res_data.is_a?(Hash) ? task.result.res_data : JSON.parse(task.result.res_data)

        task.result.n_zones = res_data['n_zones']
        if res_data['n_zones_by_rl'].present?
          zones_by_rl = [0]
          res_data['n_zones_by_rl'].each do |k, v|
            zones_by_rl << v
          end
        end
        task.result.n_zones_by_rl = zones_by_rl.to_s
        task.result.n_pois = res_data['n_pois']
        task.result.n_edus_tight = 0
        task.result.n_edus_loose = res_data['n_edus']
        task.result.time_classification = res_data['time_classification']
        task.result.time_positioning  = res_data['time_positioning']
        task.result.save!
      end

      task.save!
    end
  end

  def down
    remove_column :tasks, :left
    remove_column :tasks, :right
    remove_column :tasks, :bottom
    remove_column :tasks, :top
    remove_column :tasks, :polygon
    remove_column :tasks, :zone_size
    remove_column :tasks, :classes
    remove_column :tasks, :edus_loose
    remove_column :tasks, :edus_tight
    remove_column :tasks, :edu_alg
    remove_column :tasks, :pois_use_all
    
    remove_column :results, :n_zones
    remove_column :results, :n_zones_by_rl
    remove_column :results, :n_pois
    remove_column :results, :n_edus_tight
    remove_column :results, :n_edus_loose
    remove_column :results, :time_classification
    remove_column :results, :time_positioning

    drop_table :tasks_pois
    drop_table :pois
  end  
end
