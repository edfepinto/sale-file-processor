require 'rails_helper'

RSpec.describe 'Sale creation', type: :request do
  let!(:current_user) do
    password = BCrypt::Password.create('sua_senha')

    User.create(
      name: 'string',
      email: 'teste@email.com',
      password: password,
      role: 1
    )
  end

  before do
    post '/login', params: { email: current_user.email, password: current_user.password }
  end

  describe 'GET /sales/new' do
    it 'renderiza um formulário de nova venda' do
      get new_sale_path
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /sales' do
    context 'com parâmetros válidos' do
      it 'cria uma nova venda' do
        sale_params = {
          purchaser_name: 'João Qualquer',
          item_description: 'Exemplo Qualquer',
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

    context 'com argumentos inválidos' do
      it 'não foi possível criar uma nova venda' do
        sale_params = { purchaser_name: 'João Qualquer' }

        expect {
          post '/sales', params: { sale: sale_params }
        }.to_not change(Sale, :count)

        expect(response).to render_template(:new)
      end
    end
  end
end
