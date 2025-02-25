class CreatePlacements < ActiveRecord::Migration[8.0]
  def change
    create_table :placements, id: :uuid do |t|
      t.belongs_to :order, null: false, foreign_key: true, type: :uuid
      t.belongs_to :product, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
