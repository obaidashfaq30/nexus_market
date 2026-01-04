class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :tenant, null: false, foreign_key: true
      t.integer :total_cents, null: false
      t.integer :status

      t.timestamps
    end
  end
end
