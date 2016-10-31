class RenameBookmarksToFavorites < ActiveRecord::Migration[5.0]
  def change
    rename_table :bookmarks, :favorites
  end
end
