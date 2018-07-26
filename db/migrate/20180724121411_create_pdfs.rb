class CreatePdfs < ActiveRecord::Migration[5.2]
  def change
    create_table :pdfs do |t|
      t.string :name
      t.datetime :last_access

      t.timestamps
    end
  end
end
