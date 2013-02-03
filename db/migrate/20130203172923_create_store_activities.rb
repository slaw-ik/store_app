class CreateStoreActivities < ActiveRecord::Migration
  def change
    create_table :store_activities do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :status_id
      t.integer :count
      t.boolean :critical
      t.integer :remainder
      t.date :move_date

      t.timestamps
    end
  end
end
