class Company < ApplicationRecord
  has_rich_text :description

  #validations
  validates :name, :zip_code, presence: true
  validate :is_email_domain_valid?

  #callbacks
  before_save :set_address

  def self.fetch_address(zip_code)
    return {} unless zip_code.present?
    address_hash = ZipCodes.identify(zip_code)
  end

  private

  def set_address
    address_hash = Company.fetch_address(zip_code)
    self.state = address_hash[:state_code]
    self.city = address_hash[:city]
  end

  def is_email_domain_valid?
    if email.present? && !(email.ends_with? "@getmainstreet.com")
      errors.add(:email, "address is not valid")
    end
  end
end
