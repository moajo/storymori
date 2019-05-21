class RenameColumnToPages < ActiveRecord::Migration[5.2]
  def change
    rename_column :pages, :title, :name
  end
end
