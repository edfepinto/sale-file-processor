class AddForeignKeyToSales < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :sales, :users, name: "fk_rails_8e94f16ccc"
    add_foreign_key :sales, :users, on_delete: :cascade, name: "user_foreign_key"
  end
end
