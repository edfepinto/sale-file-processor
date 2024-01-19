class Sale < ApplicationRecord
  belongs_to :user
  
  validates :purchaser_name, presence: { message: "Campo obrigatório" }
  validates :item_description, presence: { message: "Campo obrigatório" }
  validates :item_price, presence: { message: "Campo obrigatório" }
  validates :purchase_count, presence: { message: "Campo obrigatório" }
  validates :merchant_address, presence: { message: "Campo obrigatório" }
  validates :merchant_name, presence: { message: "Campo obrigatório" }

  def self.calculate_total_balance(parsed_data)
    total_balance = parsed_data.sum { |data| data['item_price'].to_f * data['purchase_count'].to_i }
    total_balance
  end
end
