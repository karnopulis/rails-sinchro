class AddFlatToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :flat, :string
  end
end
