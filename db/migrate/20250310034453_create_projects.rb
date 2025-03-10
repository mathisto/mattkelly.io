class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :technologies_used, null: false, default: '[]'
      t.string :role
      t.string :duration
      t.string :github_url
      t.string :live_site_url
      t.string :screenshot_url
      t.boolean :highlight, null: false, default: false
      t.integer :position, null: false

      t.timestamps

      t.index :highlight
      t.index :position
    end
  end
end
