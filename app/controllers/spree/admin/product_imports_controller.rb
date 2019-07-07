module Spree
  module Admin
    class ProductImportsController < Spree::Admin::BaseController
      before_action :authorize

      def create
        file_import = FileImport.new(file: import_params['file'])

        if file_import.save
          Spree::Admin::ProductImportJob.perform_async(file_import.id)

          flash[:notice] = 'Please refresh while status is pending or processing'
          redirect_to admin_product_import_path(file_import)
        else
          flash[:error] = "#{ file_import.errors.full_messages.join('. ') }.
            Fix error and try again."
          redirect_to request.referer
        end
      end

      def show
        @file_import = FileImport.find_by(id: params[:id])
      end

      private

      def import_params
        if params[:file_import] && params[:file_import].present?
          params.require(:file_import).permit(:file)
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
