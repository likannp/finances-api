require 'rails_helper'

RSpec.describe V1::TransactionsController, '#update', type: :request do
  let(:setup) {}
  let(:body) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:transaction) { create(:transaction, account: account) }

  let(:params) do
    {
      description: 'Cinema',
      amount: 25.0,
      spent_at: Date.today.to_time.iso8601,
      transaction_type: 'expense'
    }
  end
  let(:headers) { authorization_header(user) }

  before do
    setup
    put v1_transaction_path(transaction), params: params, headers: headers
  end

  include_context 'when the user is not authenticated'

  context 'when the user is authenticated' do
    context 'and the transaction belongs to the current user' do
      it { expect(response).to have_http_status(:ok) }
      it do
        expected_category = {
          'id' => transaction.category_id,
          'description' => transaction.category_description,
          'parent_category_id' => nil,
          'child_categories' => []
        }
        expected_account = {
          'id' => account.id,
          'name' => account.name,
          'description' => account.description
        }
        expect(response_body).to include('description' => params[:description])
          .and include('amount' => params[:amount].to_s)
          .and include('spent_at' => params[:spent_at])
          .and include('transaction_type' => params[:transaction_type])
          .and include('category' => expected_category)
          .and include('account' => expected_account)
      end
    end

    context 'and the transaction does not exist' do
      let(:transaction) { -1 }

      it { expect(response).to have_http_status(:not_found) }
      it do
        error_message = "Couldn't find Transaction with 'id'=-1"
        expect(body).to include('errors' => error_message)
      end
    end

    context 'and the update action fails' do
      let(:setup) { allow_any_instance_of(Transaction).to receive(:update).and_return(false) }

      it do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body).to include('message' => 'Unprocessable Entity')
      end
    end
  end
end
