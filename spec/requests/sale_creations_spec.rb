require 'rails_helper'

RSpec.describe 'Sale creation', type: :request do
  describe 'GET /sales/new' do
    it 'Renderiza um formulário de nova venda' do
      get new_sale_path
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /sales' do
    context 'with valid parameters' do
      it 'Criar uma nova venda' do
        sale_params = {
          purchaser_name: 'João Qualquer',
          item_description: 'Examplo Qualquer',
          item_price: 20.0,
          purchase_count: 2,
          merchant_address: 'Esplanada',
          merchant_name: 'Exemplo qualquer'
        }

        expect {
          post '/sales', params: { sale: sale_params }
        }.to change(Sale, :count).by(1)

        expect(response).to redirect_to(list_sales_sales_path)                
        expect(flash[:success]).to include('Venda adicionada com sucesso.')
      end
    end

    context 'Com arguementos invalídos' do
      it 'Não foi possivel criar uma nova venda' do
        sale_params = { purchaser_name: 'João Qualquer' }

        expect {
          post '/sales', params: { sale: sale_params }
        }.to_not change(Sale, :count)

        expect(response).to render_template(:new)
      end
    end
  end
end
