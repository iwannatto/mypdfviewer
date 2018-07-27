class PdfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # logger.debug(record.pdf.class)
    if value.blob.filename.extension != 'pdf'
      record.errors.add(attribute, 'file should be pdf.')
    end
  end
end