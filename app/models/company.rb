class Company < ApplicationRecord
  has_rich_text :description

  #validations
  validates :name, :zip_code, presence: true
  validate :is_email_domain_valid?

  private

  def is_email_domain_valid?
    if email.present? && !(email.ends_with? "@getmainstreet.com")
      errors.add(:email, "address is not valid")
    end
  end
end
