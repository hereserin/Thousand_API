class CreatePagesOutboundLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :pages_outbound_links do |t|
      t.integer :page_id, null: false
      t.integer :outbound_link_id, null: false
    end
    add_index :pages_outbound_links, [:page_id, :outbound_link_id], unique: true
    add_index :pages_outbound_links, :page_id
    add_index :pages_outbound_links, :outbound_link_id
  end
end
