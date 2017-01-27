class AddCompareRefToVariants < ActiveRecord::Migration[5.0]
  def change
    add_reference :variants, :compare, foreign_key: true
  end
end
