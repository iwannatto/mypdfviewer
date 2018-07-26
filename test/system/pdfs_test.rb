require "application_system_test_case"

class PdfsTest < ApplicationSystemTestCase
  setup do
    @pdf = pdfs(:one)
  end

  test "visiting the index" do
    visit pdfs_url
    assert_selector "h1", text: "Pdfs"
  end

  test "creating a Pdf" do
    visit pdfs_url
    click_on "New Pdf"

    fill_in "Last Access", with: @pdf.last_access
    fill_in "Name", with: @pdf.name
    click_on "Create Pdf"

    assert_text "Pdf was successfully created"
    click_on "Back"
  end

  test "updating a Pdf" do
    visit pdfs_url
    click_on "Edit", match: :first

    fill_in "Last Access", with: @pdf.last_access
    fill_in "Name", with: @pdf.name
    click_on "Update Pdf"

    assert_text "Pdf was successfully updated"
    click_on "Back"
  end

  test "destroying a Pdf" do
    visit pdfs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pdf was successfully destroyed"
  end
end
