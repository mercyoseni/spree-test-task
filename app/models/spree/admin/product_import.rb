module Spree
  module Admin
    class ProductImport
      require 'csv'
      include ActiveModel::Model

      attr_reader :shipping_category

      def initialize
        @shipping_category = Spree::ShippingCategory.find_or_create_by!(
          name: 'Default'
        )
        super
      end

      def import(file_import_id)
        @row_number = 0
        @file_import = FileImport.find_by(id: file_import_id)

        CSV.foreach(@file_import.file.path, headers: true, col_sep: ';') do |row|
          @file_import.update(state: 'Processing')
          params = row_to_params(row)
          @row_number += 1

          begin
            Spree::Product.transaction do
              existing_product = Spree::Product.find_by(slug: row['slug'])

              product =
                if existing_product.present?
                  update_product(existing_product, params) # update the existing product
                else
                  create_product(params) # create product using the params
                end

              if product
                set_taxon(product, row['category']) if row['category'].present?
                set_stock_total(product, row['stock_total']) if row['stock_total'].present?
              end
            end
          rescue => e
            errors.add(:base, "Row #{ @row_number }: #{ e.message }")
          end
        end

        update_file_import
      end

      private

      def update_file_import
        @file_import.update!(
          row_count: @row_number,
          error: errors.full_messages,
          success_count: @row_number - errors.full_messages.size,
          state: 'Completed'
        )
      end

      def row_to_params(row)
        {
          name: row['name'],
          description: row['description'],
          price: row['price'] && row['price'].sub(',', '.').to_f, # convert price to float
          available_on: row['availability_date'],
          slug: row['slug'],
          shipping_category_id: shipping_category.id # set default shipping category
        }
      end

      def update_product(product, params)
        product.update!(params)
        product
      end

      def create_product(params)
        Spree::Product.create!(params)
      end

      def set_taxon(product, name)
        categories_taxonomy = Spree::Taxonomy.first
        taxon = Spree::Taxon.find_by(name: name) ||
        Spree::Taxon.create!(name: name, taxonomy: categories_taxonomy)

        # add taxon only when it's not already linked
        product.taxons << taxon unless product.taxons.include?(taxon)
      end

      def set_stock_total(product, stock_total)
        variant = Spree::Variant.find_by(product_id: product.id)
        stock_location = Spree::StockLocation.first
        stock_item = Spree::StockItem.find_or_create_by!(
          variant_id: variant.id,
          stock_location: stock_location
        )
        stock_item.count_on_hand = stock_total

        stock_item.save!
      end
    end
  end
end
