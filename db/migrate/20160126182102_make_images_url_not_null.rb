class MakeImagesUrlNotNull < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute('DELETE FROM images WHERE url IS NULL')
      end
    end

    change_column_null :images, :url, false
  end
end
