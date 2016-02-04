class MakeTagsNameNotNull < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute('DELETE FROM tags WHERE name IS NULL')
      end
    end

    change_column_null :tags, :name, false
  end
end
