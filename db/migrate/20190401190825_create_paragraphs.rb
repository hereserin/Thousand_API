class CreateParagraphs < ActiveRecord::Migration[5.2]
  def change
    create_table :paragraphs do |t|
      t.integer :page_id, null: false
      t.text :content, null: false
    end
    add_index :paragraphs, :page_id
  end
end
