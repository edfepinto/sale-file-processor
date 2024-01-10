class Sale < ApplicationRecord
  # mount_uploader :file, FileUploader

  def self.calculate_total_balance(parsed_data)
    total_balance = parsed_data.sum { |data| data['item_price'].to_f * data['purchase_count'].to_i }
    total_balance
  end
end
