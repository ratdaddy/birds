class CreateNodes < ActiveRecord::Migration[7.1]
  def change
    create_table :nodes do |t|
      t.references :parent, null: true, index: true, foreign_key: { to_table: :nodes }

      t.timestamps null: true
    end
  end
end
