class Sale < ApplicationRecord
  belongs_to :user
  validates :item_price, presence: true
  validates :purchaser_name, length: { minimum: 10, maximum: 30 }
  validates :item_description, length: { minimum: 10, maximum: 30 }
  validates :item_price, numericality: { greater_than_or_equal_to: 10, less_than_or_equal_to: 1000 }
  validates :purchase_count, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :merchant_address, length: { minimum: 10, maximum: 30 }
  validates :merchant_name, length: { minimum: 10, maximum: 30 }
  
  def self.calculate_total_balance(parsed_data)
    total_balance = parsed_data.sum { |data| data['item_price'].to_f * data['purchase_count'].to_i }
    total_balance
  end
end
