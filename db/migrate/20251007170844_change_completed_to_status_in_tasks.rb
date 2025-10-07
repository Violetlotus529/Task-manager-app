class ChangeCompletedToStatusInTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :comleted, :boolean
    add_column :tasks, :status, :integer, default: 0, null: false
  end
end
