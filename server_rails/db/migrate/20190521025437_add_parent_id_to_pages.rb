class AddParentIdToPages < ActiveRecord::Migration[5.2]
  def change
    add_reference :pages, :parent, foreign_key: { to_table: :pages }
  end
end
