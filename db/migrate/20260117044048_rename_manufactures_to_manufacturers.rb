class RenameManufacturesToManufacturers < ActiveRecord::Migration[7.2]
  def change
    rename_table :manufactures, :manufacturers
  end
end
