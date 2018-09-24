class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.string :endpoint
      t.string :p256dh
      t.string :auth

      t.timestamps
    end
    add_index :subscriptions, :user_id
  end
end
