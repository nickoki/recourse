class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.string :vote_type, null: false

      t.timestamps
    end
  end
end
