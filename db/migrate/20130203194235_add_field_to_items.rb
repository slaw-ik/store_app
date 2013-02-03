class AddFieldToItems < ActiveRecord::Migration
  def change
    add_column :items, :removed, :boolean
  end
end
