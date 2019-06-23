module Spree
  module Admin
    class ProductImportsController < ResourceController
      def create
        @product_import = Spree::ProductImport.new
        @product_import.file = import_params['csv_file']

        # don't redirect to the new page if file is invalid
        unless @product_import.valid?
          flash[:error] = "#{ @product_import.errors.full_messages.join }. Fix error and try again."
          return redirect_to admin_products_path
        end

        if @product_import.valid? &&
          @product_import.import &&
          @product_import.errors.full_messages.empty?
          flash.now[:success] = 'Products imported successfully!'
        end
      end

      private

      def import_params
        if params[:product_import] && params[:product_import].present?
          params.require(:product_import).permit(:csv_file)
        else
          {}
        end
      end
    end
  end
end
