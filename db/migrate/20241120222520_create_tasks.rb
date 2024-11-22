class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.string :status, null: false, default: 'pending'
      t.string :task_type, null: false, default: 'generic'

      t.timestamps
    end
  end
end
