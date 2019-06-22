module Spree
  module Admin
    class ProductImportsController < Spree::Admin::BaseController
      def create
        import_init = Spree::ProductImport.new
        import_init.file = params[:csv_file]

        if import_init.valid? &&
          import_init.import(params[:csv_file]) &&
          import_init.errors.full_messages.empty?
          flash[:success] = 'Products imported successfully!'
        else
          flash[:error] = "#{ import_init.errors.full_messages.uniq.join }.
            Fix error and try again."
        end

        redirect_to admin_products_url
      end
    end
  end
end
