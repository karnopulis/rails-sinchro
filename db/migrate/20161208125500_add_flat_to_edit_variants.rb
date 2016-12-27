class AddFlatToEditVariants < ActiveRecord::Migration
  def change
    add_column :edit_variants, :flat, :string
  end
end
