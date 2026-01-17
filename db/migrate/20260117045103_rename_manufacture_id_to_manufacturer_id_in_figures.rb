class RenameManufactureIdToManufacturerIdInFigures < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :figures, :manufacturers
    rename_column :figures, :manufacture_id, :manufacturer_id
    add_foreign_key :figures, :manufacturers, column: :manufacturer_id
  end
end
