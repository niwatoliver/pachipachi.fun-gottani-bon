class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :image_url
      t.string :token
      t.string :secret
      t.string :remember_token

      t.timestamps
    end
  end
end
