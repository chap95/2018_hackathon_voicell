class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :alt
      t.string :hint
      t.string :file
      t.integer :bulletin_id

      t.timestamps
    end
  end
end
