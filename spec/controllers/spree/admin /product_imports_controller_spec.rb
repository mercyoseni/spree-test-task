require 'rails_helper'

RSpec.describe Spree::Admin::ProductImportsController, type: :controller do
  stub_authorization!

  let(:valid_file) { file_fixture('valid_sample.csv').to_s }

  describe '#create' do
    context 'when file is provided' do
      context 'when file content type is text/csv' do
        it 'renders the product imports page' do
          file = fixture_file_upload(valid_file, 'text/csv')

          post :create, params: { product_import: { csv_file: file } }

          assert_template 'admin/product_imports/create'
          expect(response).to have_http_status(200)
        end
      end

      context 'when file content type is NOT text/csv' do
        it 'redirects to admin products path' do
          file = fixture_file_upload(valid_file, 'text/plain')

          post :create, params: { product_import: { csv_file: file } }

          expect(response).to have_http_status(302)
          expect(response).to redirect_to(admin_products_path)
        end
      end
    end

    context 'when file is NOT provided' do
      it 'redirects to products page' do
        post :create, params: { product_import: { csv_file: nil } }

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(admin_products_path)
      end
    end
  end
end
