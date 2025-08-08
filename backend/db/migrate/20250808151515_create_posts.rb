class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
    change_column_null :posts, :user_id,     false
    change_column_null :posts, :trip_id,     false
    change_column_null :posts, :location_id, false
    add_index :posts, [ :trip_id, :created_at ]
  end
end
