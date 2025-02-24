class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :title
      t.decimal :price
      t.boolean :published
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
