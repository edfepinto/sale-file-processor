class Sale < ApplicationRecord
  belongs_to :user
  validates :item_price, presence: true
  
  def self.calculate_total_balance(parsed_data)
    total_balance = parsed_data.sum { |data| data['item_price'].to_f * data['purchase_count'].to_i }
    total_balance
  end
end
