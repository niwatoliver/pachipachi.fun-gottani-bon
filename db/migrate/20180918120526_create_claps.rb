class CreateClaps < ActiveRecord::Migration[5.2]
  def change
    create_table :claps do |t|
      t.integer :from_user_id
      t.integer :to_user_id

      t.timestamps
    end
    add_index :claps, :from_user_id
    add_index :claps, :to_user_id
  end
end
