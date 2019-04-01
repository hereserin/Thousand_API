class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :url, null: false
      t.string :title
      t.decimal :page_rank
    end
    add_index :pages, :url, unique: true
  end
end
