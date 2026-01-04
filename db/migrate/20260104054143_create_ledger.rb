class CreateLedger < ActiveRecord::Migration[7.2]
  def change
    create_table :ledgers do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :total_amount

      t.timestamps
    end
  end
end
