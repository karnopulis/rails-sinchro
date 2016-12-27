class AddOriginalidToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :original_id, :integer
  end
end
