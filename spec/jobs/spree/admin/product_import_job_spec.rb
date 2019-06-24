require 'rails_helper'

RSpec.describe Spree::Admin::ProductImportJob, type: :job do
  describe '#perform' do
    it 'calls Spree::Admin::ProductImport#import' do
      expect_any_instance_of(Spree::Admin::ProductImport)
        .to receive(:import)
        .with('test.csv', 2)

      described_class.new.perform('test.csv', 2)
    end
  end
end
