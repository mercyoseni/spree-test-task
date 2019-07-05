module Spree
  module Admin
    class ProductImportJob
      include Sidekiq::Worker

      def perform(file_import_id)
        product_import = Spree::Admin::ProductImport.new
        product_import.import(file_import_id)
      end
    end
  end
end
