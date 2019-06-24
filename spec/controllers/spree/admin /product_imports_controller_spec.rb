require 'rails_helper'

RSpec.describe Spree::Admin::ProductImportsController, type: :controller do
  stub_authorization!

  let(:valid_file) { file_fixture('valid_sample.csv').to_s }

  describe '#create' do
    context 'when file is provided' do
      context 'when file content type is text/csv' do
        it 'enqueues the job and redirects to the imports status page' do
          expect(Spree::Admin::ProductImportJob).to receive(:perform_async)

          file = fixture_file_upload(valid_file, 'text/csv')
          post :create, params: { admin_product_import: { csv_file: file } }
          file_import = FileImport.last

          expect(response).to have_http_status(302)
          expect(response).to redirect_to(admin_product_import_path(file_import))
        end
      end

      context 'when file content type is NOT text/csv' do
        it 'redirects to admin products page' do
          file = fixture_file_upload(valid_file, 'text/plain')
          request.env['HTTP_REFERER'] = admin_products_path

          post :create, params: { admin_product_import: { csv_file: file } }

          expect(response).to have_http_status(302)
          expect(response).to redirect_to(admin_products_path)
        end
      end
    end

    context 'when file is NOT provided' do
      it 'redirects to admin products page' do
        request.env['HTTP_REFERER'] = admin_products_path

        post :create, params: { admin_product_import: { csv_file: nil } }

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(admin_products_path)
      end
    end
  end
end
