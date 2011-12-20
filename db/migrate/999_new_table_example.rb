class NewTableExample < ActiveRecord::Migration
  def self.up
    create_table :table do |t|
      t.index :id
    end
  end

  def self.down
    drop_table :table
  end
end
