class MakeTaggingsFieldsNotNull < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          DELETE FROM taggings
          WHERE tag_id IS NULL OR taggable_id IS NULL
                OR taggable_type IS NULL
        SQL
      end
    end

    change_column_null :taggings, :tag_id, false
    change_column_null :taggings, :taggable_id, false
    change_column_null :taggings, :taggable_type, false
  end
end
