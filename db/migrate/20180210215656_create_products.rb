class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :stripe_id

      t.timestamps
    end

    create_table :subscriptions do |t|
      t.integer :product_id
      t.integer :user_id
      t.boolean :subscribed, default: false
    end
  end
end
