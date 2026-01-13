class CreateFigures < ActiveRecord::Migration[7.2]
  def change
    create_table :figures do |t|
      t.string :name, null: false
      t.date :release_month, null: false
      t.integer :quantity, null: false
      t.integer :price, null: false
      t.integer :payment_status, null: false
      t.integer :size_type
      t.integer :size_mm
      t.text :note
      t.references :user, foreign_key: true
      t.references :manufacture, foreign_key: true
      t.references :work, foreign_key: true
      t.references :shop, foreign_key: true

      t.timestamps
    end
  end
end
