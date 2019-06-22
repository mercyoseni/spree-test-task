module Spree
  class ProductImport
    include ActiveModel::Model

    attr_accessor :file

    def import(csv_file)
      CSV.foreach(csv_file.path, headers: true, col_sep: ';') do |row|
        # skip invalid row but display the error after the import
        # TODO: implement displaying the row number with the related error
        next unless params = row_to_params(row)

        existing_product = Spree::Product.find_by_slug(row['slug'])

        product =
          if existing_product.present?
            update_product(existing_product, params) # update the existing product
          else
            create_product(params) # create product using the params
          end

        set_taxon(product, row['category']) if row['category'].present?
        set_stock_total(product, row['stock_total']) if row['stock_total'].present?
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
        errors.add(:file, 'is empty')
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
      required_params = %w(name price slug)

      if required_params.all? { |param| row[param].present? }
        {
          name: row['name'],
          description: row['description'],
          price: row['price'].sub(',', '.').to_f, # convert price to float
          available_on: row['availability_date'],
          slug: row['slug'],
          shipping_category_id: set_shipping_category.id # set default shipping category
        }
      else
        errors.add(
          :base,
          "Please include all attributes. Name, Price and Slug can't be blank"
        )
        nil
      end
    end

    def update_product(product, params)
      product.update(params)
      product
    end

    def create_product(params)
      product = Spree::Product.create(params)
      product
    end

    def set_taxon(product, name)
      categories_taxonomy = Spree::Taxonomy.first
      taxon = Spree::Taxon.find_by_name(name) ||
      Spree::Taxon.create(name: name, taxonomy: categories_taxonomy)

      # add taxon only when it's not already linked
      product.taxons << taxon unless product.taxons.include?(taxon)
    end

    def set_stock_total(product, stock_total)
      variant = Spree::Variant.find_by_product_id(product.id)
      stock_location = Spree::StockLocation.first
      stock_item = Spree::StockItem.find_or_create_by(
        variant_id: variant.id,
        stock_location: stock_location
      )
      stock_item.count_on_hand = stock_total

      stock_item.save
    end

    def set_shipping_category
      Spree::ShippingCategory.find_or_create_by(name: 'Default')
    end
  end
end
