class SalesController < ApplicationController
  before_action :require_login, except: [:upload_form, :calculate_balance, :show_result]

  def upload_form
    @sale = Sale.new
  end

  def new
    @sale = Sale.new
  end

  def create
    @sale = current_user.sales.build(sale_params)
    
    if @sale.save
      flash[:success] = 'Venda adicionada com sucesso.'
      redirect_to list_sales_sales_path
    else
      flash.now[:alert] = 'Erro ao adicionar venda.'
      render :new
    end
  end

  def edit
    @sale = current_user.sales.find(params[:id])
  end

  def update
    @sale = current_user.sales.find(params[:id])

    if @sale.update(sale_params)
      flash[:success] = 'Venda atualizada com sucesso.'
      redirect_to list_sales_sales_path
    else
      flash.now[:alert] = 'Erro ao atualizar venda.'
      render :edit
    end
  end

  def destroy
    @sale = current_user.sales.find(params[:id])
    @sale.destroy
    flash[:success] = 'Venda excluída com sucesso.'
    redirect_to list_sales_sales_path
  end

  def list_sales
    @sales = current_user.sales.paginate(page: params[:page], per_page: 10)

    if params[:search_term].present?
      search_term = "%#{params[:search_term]}%"
      @sales = @sales.where(
        "CAST(purchaser_name AS TEXT) LIKE ? OR CAST(item_description AS TEXT) LIKE ? OR CAST(item_price AS TEXT) LIKE ? OR CAST(purchase_count AS TEXT) LIKE ? OR CAST(merchant_address AS TEXT) LIKE ? OR CAST(merchant_name AS TEXT) LIKE ?", 
        search_term, search_term, search_term, search_term, search_term, search_term
      )
    end

    respond_to do |format|
      format.html do
        if @sales.empty?
          flash.now[:notice] = "Nenhum resultado encontrado para a pesquisa."
        end
      end
      format.json { render json: @sales }
    end
  end

  def show_result
    @total_balance = flash[:total_balance]
  end

  def calculate_balance
    begin
      if params[:sale] && params[:sale][:file].present?
        file_content = params[:sale][:file].read
        parsed_data = parse_file_content(file_content)

        if parsed_data.present?
          current_user.sales.destroy_all

          parsed_data.each do |data|
            @sale = current_user.sales.build(data)

            unless @sale.save
              flash[:alert] = "Falha no processamento do arquivo."
              redirect_to upload_form_sales_path
              return
            end
          end

          total_balance = Sale.calculate_total_balance(parsed_data)
          flash[:total_balance] = total_balance
          redirect_to show_result_sales_path
        else
          flash[:alert] = "Falha no processamento do arquivo."
          redirect_to upload_form_sales_path
        end
      else
        flash[:alert] = "Arquivo não encontrado."
        redirect_to upload_form_sales_path
      end
    rescue StandardError => e
      flash[:alert] = "Erro durante o processamento do arquivo: #{e.message}"
      redirect_to list_sales_sales_path
    end
  end

  private

  def sale_params
    params.require(:sale).permit(
      :purchaser_name, 
      :item_description, 
      :item_price, 
      :purchase_count, 
      :merchant_address, 
      :merchant_name
    )
  end

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
