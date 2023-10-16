class AlterTableArticle < ActiveRecord::Migration[7.0]
  def change
    rename_column :articles, :creator_id, :user_id
    change_column :articles, :user_id, :integer, null: false
  end
end
