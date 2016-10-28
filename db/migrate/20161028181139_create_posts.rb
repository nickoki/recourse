class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :link
      t.string :title
      t.string :level
      t.text :desc_what
      t.text :desc_why
      t.text :desc_who
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
