class AddIndexedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :collection_indexed, :boolean, default: false
  end
end
