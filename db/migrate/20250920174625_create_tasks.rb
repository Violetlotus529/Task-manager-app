class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.datetime :deadline

      t.timestamps
    end
  end
end
