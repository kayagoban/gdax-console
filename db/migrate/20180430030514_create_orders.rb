class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :side
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :size, :precision => 18, :scale => 9

      t.timestamps
    end
    add_index :orders, :side
  end
end
