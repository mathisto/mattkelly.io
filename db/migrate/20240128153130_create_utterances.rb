class CreateUtterances < ActiveRecord::Migration[7.1]
  def change
    create_table :utterances do |t|
      t.string :text
      t.string :user_agent

      t.timestamps
    end
  end
end
