module Spree
  module Admin
    class ProductImportsController < Spree::Admin::BaseController
      def create
        Spree::ProductImport.new.import(params[:csv_file])

        flash[:success] = 'Products imported successfully!'
        redirect_to admin_products_url
      end
    end
  end
end
