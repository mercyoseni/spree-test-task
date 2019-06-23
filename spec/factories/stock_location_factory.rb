FactoryBot.define do
  factory :stock_location, class: Spree::StockLocation do
    name { Faker::Name.unique.name }
  end
end
