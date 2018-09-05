class AddPdfAndJpegsFilesizeToPdfs < ActiveRecord::Migration[5.2]
  def change
    add_column :pdfs, :pdf_and_jpegs_filesize, :integer
  end
end
