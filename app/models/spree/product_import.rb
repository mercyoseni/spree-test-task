module Spree
  class ProductImport
    require 'csv'
    include ActiveModel::Model

    attr_accessor :file

    def row_count
      @row_number
    end

    def import
      @row_number = 0

      CSV.foreach(file.path, headers: true, col_sep: ';') do |row|
        params = row_to_params(row)
        @row_number += 1

        begin
          Spree::Product.transaction do
            existing_product = Spree::Product.find_by_slug(row['slug'])

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

      true
    end

    def valid?
      validate_file? && validate_content_type?
    end

    private

    def validate_file?
      if file.present?
        true
      else
        errors.add(:base, 'No file chosen')
        false
      end
    end

    def validate_content_type?
      if file.content_type == 'text/csv'
        true
      else
        errors.add(:file, 'content type not allowed')
        false
      end
    end

    def row_to_params(row)
      {
        name: row['name'],
        description: row['description'],
        price: row['price'] && row['price'].sub(',', '.').to_f, # convert price to float
        available_on: row['availability_date'],
        slug: row['slug'],
        shipping_category_id: set_shipping_category.id # set default shipping category
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
      taxon = Spree::Taxon.find_by_name(name) ||
      Spree::Taxon.create!(name: name, taxonomy: categories_taxonomy)

      # add taxon only when it's not already linked
      product.taxons << taxon unless product.taxons.include?(taxon)
    end

    def set_stock_total(product, stock_total)
      variant = Spree::Variant.find_by_product_id(product.id)
      stock_location = Spree::StockLocation.first
      stock_item = Spree::StockItem.find_or_create_by!(
        variant_id: variant.id,
        stock_location: stock_location
      )
      stock_item.count_on_hand = stock_total

      stock_item.save!
    end

    def set_shipping_category
      Spree::ShippingCategory.find_or_create_by!(name: 'Default')
    end
  end
end
