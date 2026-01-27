class AddTotalPriceToFigures < ActiveRecord::Migration[7.2]
  def change
    add_column :figures, :total_price, :integer, null: false, default: 0
  end
end
