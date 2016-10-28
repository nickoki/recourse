class AddPubDateToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :pub_date, :date
  end
end
