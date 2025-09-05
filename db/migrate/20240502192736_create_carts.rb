class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.integer :status, default: 0
      t.decimal :total_price, precision: 17, scale: 2
      t.timestamps
    end

    add_index :carts, :status
    add_index :carts, :updated_at
  end
end
