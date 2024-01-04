class Sale < ApplicationRecord
  mount_uploader :file, FileUploader

  def self.calculate_total_balance
    # TODO: processar o arquivo e calcular o saldo total
  end
end
