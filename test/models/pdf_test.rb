require 'test_helper'

class PdfTest < ActiveSupport::TestCase
  test "should not save pdf without name" do
    pdf = Pdf.new
    assert_not pdf.save, "saved"
  end
end
