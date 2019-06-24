module Spree
  module Admin
    class ProductImportJob
      include Sidekiq::Worker

      def perform(filepath, file_import_id)
        product_import = Spree::ProductImport.new
        product_import.import(filepath, file_import_id)
      end
    end
  end
end
