require 'rails_helper'

RSpec.describe Spree::Admin::ProductImport, type: :model do
  let!(:product_import) { described_class.new }
  let!(:stock_location) { create(:stock_location) }
  let!(:shipping_category) { create(:shipping_category) }
  let(:valid_file) { file_fixture('valid_sample.csv').to_s }
  let(:invalid_file) { file_fixture('invalid_sample.csv').to_s }

  describe '#valid?' do
    context 'when the file is present' do
      context 'when the file content type is text/csv' do
        it 'returns true' do
          product_import.file = fixture_file_upload(valid_file, 'text/csv')
          expect(product_import.valid?).to be true
        end
      end

      context 'when the file content type is NOT text/csv' do
        it 'returns false' do
          product_import.file = fixture_file_upload(invalid_file, 'text/pdf')
          expect(product_import.valid?).to be false
          expect(product_import.errors.full_messages.join)
            .to eq('File content type not allowed')
        end
      end
    end

    context 'when the file is NOT present' do
      it 'returns false' do
        expect(product_import.valid?).to be false
        expect(product_import.errors.full_messages.join)
          .to eq('No file chosen')
      end
    end
  end

  describe '#import' do
    context 'when the file contains valid products' do
      let(:last_product) { Spree::Product.last }

      before do
        product_import.file = fixture_file_upload(valid_file, 'text/csv')
        @filepath = product_import.file.tempfile
        @file_import = FileImport.create!(
          filename: product_import.file.original_filename
        )
      end

      it 'creates a new product with taxon' do
        expect do
          product_import.import(@filepath, @file_import.id)
          @file_import.reload
        end.to change { Spree::Product.count }.by(1)
          .and change { Spree::Taxon.count }.by(1)
        expect(@file_import.row_count).to eq(1)
        expect(@file_import.state).to eq('Completed')
        expect(@file_import.error).to be_empty
        expect(last_product.name).to eq('Spree Bag')
        expect(last_product.description).to eq('Lorem ipsum dolor.')
        expect(last_product.price).to eq(25.99)
        expect(last_product.available_on.to_date)
          .to eq(Date.parse('2017-12-04T14:55:22.913Z'))
        expect(last_product.price).to eq(25.99)
        expect(last_product.slug).to eq('spree-bag')
        expect(last_product.total_on_hand).to eq(5)
        expect(last_product.taxons.count).to eq(1)
        expect(last_product.taxons.first.name).to eq('Bags')
      end

      it 'updates an existing product and adds taxon' do
        existing_product = Spree::Product.create!({
          name: 'Test Spree Bag',
          slug: 'spree-bag',
          description: 'Test Lorem ipsum',
          price: 18.90,
          available_on: 2.days.ago,
          shipping_category: shipping_category
        })

        expect do
          product_import.import(@filepath, @file_import.id)
          existing_product.reload
          @file_import.reload
        end.to change { Spree::Product.count }.by(0)
          .and change { existing_product.taxons.count }.by(1)
          .and change { existing_product.name }.to('Spree Bag')
          .and change { existing_product.price }.to(25.99)
          .and change { existing_product.available_on.to_date }
            .to(Date.parse('2017-12-04T14:55:22.913Z'))
          .and change { existing_product.total_on_hand }.to(5)
        expect(existing_product.taxons.first.name).to eq('Bags')
        expect(@file_import.row_count).to eq(1)
        expect(@file_import.state).to eq('Completed')
        expect(@file_import.error).to be_empty
      end
    end

    context 'when the file contains valid and invalid products' do
      before do
        product_import.file = fixture_file_upload(invalid_file, 'text/csv')
        @filepath = product_import.file.tempfile
        @file_import = FileImport.create!(
          filename: product_import.file.original_filename
        )
      end

      it 'creates products from valid rows and generates error for invalid rows' do
        expect do
          product_import.import(@filepath, @file_import.id)
          @file_import.reload
        end.to change { Spree::Product.count }.by(2)
          .and change { Spree::Taxon.count }.by(1)
        expect(@file_import.row_count).to eq(4)
        expect(@file_import.state).to eq('Completed')
        expect(@file_import.error.count).to eq(2)
        expect(@file_import.error).to eq([
          "Row 2: Validation failed: Must supply price for variant or master price for product., Name can't be blank, Price can't be blank",
          "Row 4: Validation failed: Name can't be blank"
        ])
      end
    end
  end
end
