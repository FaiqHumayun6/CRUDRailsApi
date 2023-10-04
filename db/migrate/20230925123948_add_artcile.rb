class AddArtcile < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :name, null: false
      t.integer :creator_id
    end

    add_foreign_key :articles, :users, column: :creator_id
  end
end
