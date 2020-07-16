require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show action without company address (city and state)" do
    visit company_path(@company)
    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
  end

  test "Show action with company address (city and state)" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    company = Company.last

    visit company_path(company)
    assert_text company.name
    assert_text company.phone
    assert_text company.email
    assert_text "#{company.city}, #{company.state}"
  end

  test "Update with invalid email address" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      click_button "Update Company"
    end

    assert_text "Email address is not valid"
  end

  test "Update with valid email address" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      fill_in("company_email", with: "test_company@getmainstreet.com")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
    assert_equal "Ventura", @company.city
    assert_equal "CA", @company.state
  end

  test "Create with invalid email address" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@test.com")
      click_button "Create Company"
    end

    assert_text "Email address is not valid"
  end

  test "Create with valid email address" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
    assert_equal "Waxhaw", last_company.city
    assert_equal "NC", last_company.state
  end

  test "destroy cancel the window alert" do
    visit company_path(@company)
    click_link 'Delete'
    sleep 1.seconds
    a = page.driver.browser.switch_to.alert
    assert_equal a.text, "Are you sure?"
    a.dismiss

    company_name = @company.name
    assert_equal company_name, @company.name
  end

  test "destroy accept the window alert" do
    visit company_path(@company)
    click_link 'Delete'
    sleep 1.seconds
    a = page.driver.browser.switch_to.alert
    assert_equal a.text, "Are you sure?"
    a.accept
    assert_text "Company #{@company.name} was successfully destroyed"
  end
end
