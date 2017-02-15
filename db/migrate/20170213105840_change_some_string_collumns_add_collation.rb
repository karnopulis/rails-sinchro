class ChangeSomeStringCollumnsAddCollation < ActiveRecord::Migration[5.0]
  def up
    change_column :collect_imports, :flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :collections, :flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :collections, :name, :string, :options => 'COLLATE utf8_general_cs'
    change_column :edit_offers, :flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :edit_variants, :flat, :string, :options => 'COLLATE utf8_general_cs'

    change_column :new_collections, :title, :string, :options => 'COLLATE utf8_general_cs'
    change_column :new_collections, :collection_flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :new_collects, :collection_flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :offer_imports, :prop_flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :offers, :flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :old_collections, :collection_flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :old_collects, :collection_flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :variant_imports, :pric_flat, :string, :options => 'COLLATE utf8_general_cs'
    change_column :variants, :flat, :string, :options => 'COLLATE utf8_general_cs'
  end
    def dowm
    change_column :collect_imports, :flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :collections, :flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :collections, :name, :string, :options => 'COLLATE utf8_general_ci'
    change_column :edit_offers, :flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :edit_variants, :flat, :string, :options => 'COLLATE utf8_general_ci'

    change_column :new_collections, :title, :string, :options => 'COLLATE utf8_general_ci'
    change_column :new_collections, :collection_flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :new_collects, :collection_flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :offer_imports, :prop_flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :offers, :flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :old_collections, :collection_flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :old_collects, :collection_flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :variant_imports, :pric_flat, :string, :options => 'COLLATE utf8_general_ci'
    change_column :variants, :flat, :string, :options => 'COLLATE utf8_general_ci'
  end
end
