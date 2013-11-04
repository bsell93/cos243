class RemoveConfirmationColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :confirmation, :string
  end
end
