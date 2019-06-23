module Spree
  module Admin
    class ProductImportsController < ResourceController
      def create
        @product_import = Spree::ProductImport.new
        @product_import.file = params[:csv_file]

        if @product_import.valid? &&
          @product_import.import(params[:csv_file]) &&
          @product_import.errors.full_messages.empty?
          flash.now[:success] = 'Products imported successfully!'
        else
          flash.now[:error] = 'Fix error and try again.'
        end
      end
    end
  end
end
