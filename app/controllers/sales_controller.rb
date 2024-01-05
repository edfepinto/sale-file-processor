class SalesController < ApplicationController
  def upload_form
    @sale = Sale.new
  end

  def show_result
    @total_balance = flash[:total_balance]
  end

  def calculate_balance
    if params[:sale] && params[:sale][:file].present?
      file_content = params[:sale][:file].read

      parsed_data = parse_file_content(file_content)

      if parsed_data.present?
        parsed_data.each do |data|
          @sale = Sale.new(data)

          unless @sale.save
            flash[:alert] = "Falha no processamento do arquivo."
            render :upload_form
            return
          end
        end

        total_balance = Sale.calculate_total_balance(parsed_data)
        flash[:total_balance] = total_balance
        redirect_to show_result_sales_path, notice: "Arquivo processado com sucesso!"
      else
        flash[:alert] = "Falha no processamento do arquivo."
        render :upload_form
      end
    else
      flash[:alert] = "Arquivo não encontrado."
      render :upload_form
    end
  end

  private

  def parse_file_content(content)
    lines = content.force_encoding("UTF-8").split("\n")
    header = lines.shift.split("\t").map { |column| column.downcase.gsub(" ", "_").strip }

    parsed_data = []
    lines.each do |line|
      values = line.force_encoding("UTF-8").split("\t").map(&:strip)
      data_hash = Hash[header.zip(values)]
      parsed_data << data_hash
    end

    Rails.logger.info("parsed data: #{parsed_data}")

    parsed_data
  end
end
