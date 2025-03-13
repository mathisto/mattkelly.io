class DropProjectsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :projects
  end

  def down
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :github_url
      t.string :live_url
      t.string :technologies, array: true, default: []
      t.integer :position

      t.timestamps
    end
  end
end
