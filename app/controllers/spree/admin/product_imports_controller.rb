module Spree
  module Admin
    class ProductImportsController < Spree::Admin::BaseController
      before_action :authorize

      def create
        @product_import = Spree::ProductImport.new
        @product_import.file = import_params['csv_file']

        if @product_import.valid?
          file_import = FileImport.create!(
            filename: @product_import.file.original_filename
          )

          Spree::Admin::ProductImportJob.perform_async(
            @product_import.file.tempfile.path,
            file_import.id
          )
          flash[:notice] = 'Please refresh while status is pending or processing'
          redirect_to admin_product_import_path(file_import)
        else
          flash[:error] = "#{ @product_import.errors.full_messages.join }.
            Fix error and try again."
          redirect_to request.referer
        end
      end

      def show
        @file_import = FileImport.find_by_id(params[:id])
      end

      private

      def import_params
        if params[:product_import] && params[:product_import].present?
          params.require(:product_import).permit(:csv_file)
        else
          {}
        end
      end

      def authorize
        authorize! :create, Product
      end
    end
  end
end
