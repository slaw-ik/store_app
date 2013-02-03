class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :count
      t.integer :crit_count
      t.integer :item_type

      t.timestamps
    end
  end
end
